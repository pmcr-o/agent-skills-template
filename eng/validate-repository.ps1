param()
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot

function Require-Path([string]$Relative,[string]$Type='Any'){
  $path=Join-Path $root $Relative
  $ok = if($Type -eq 'Leaf'){Test-Path -LiteralPath $path -PathType Leaf}elseif($Type -eq 'Container'){Test-Path -LiteralPath $path -PathType Container}else{Test-Path -LiteralPath $path}
  if(-not $ok){throw "missing $Relative"}
}

$shape=Get-Content -LiteralPath (Join-Path $root '.pmcro/protocol/repository-shape.json') -Raw|ConvertFrom-Json
if($shape.schema -ne 'pmcro.repository-shape/v1'){throw 'repository shape schema mismatch'}
foreach($rel in @($shape.requiredTopLevel)+@($shape.pmcroAdditions)){Require-Path ([string]$rel)}
foreach($rel in @($shape.githubSurfaces)){Require-Path ('.github/'+[string]$rel)}

$catalog=Get-Content -LiteralPath (Join-Path $root '.pmcro/control/catalog.json') -Raw|ConvertFrom-Json
foreach($skill in @($catalog.skills)){
  $base='.pmcro/plugins/'+$skill.plugin+'/skills/'+$skill.id
  Require-Path ($base+'/SKILL.md') 'Leaf'
  foreach($part in @('agents','scripts','references','assets','tests')){
    Require-Path ($base+'/'+$part) 'Container'
    $files=Get-ChildItem -LiteralPath (Join-Path $root ($base+'/'+$part)) -Recurse -File
    if(-not $files){throw "$($skill.plugin)/$($skill.id) $part is empty"}
  }
}

$hostContract=Get-Content -LiteralPath (Join-Path $root '.pmcro/protocol/host-activation.json') -Raw|ConvertFrom-Json
if($hostContract.rootSeedPhase -ne 'ORCHESTRATE'){throw 'host activation must begin at ORCHESTRATE'}
if($hostContract.activation.projectionAloneIsActivation -ne $false){throw 'projection may not equal activation'}
if($hostContract.activation.hostSpecificBootstrapRequired -ne $true){throw 'host bootstrap must be required'}
if($hostContract.activation.bootstrapMustRunContinuously -ne $true){throw 'host bootstrap must run continuously'}
if($hostContract.activation.bootstrapMayRequireHumanPhaseInvocation -ne $false){throw 'human phase gate must be disabled'}
if($hostContract.authorityCeiling.rule -ne 'inherit-or-narrow-never-widen'){throw 'authority ceiling law missing'}
if($hostContract.checker.independent -ne $true -or $hostContract.checker.makerMaySelfApprove -ne $false){throw 'independent checker law missing'}
if($hostContract.executionCadence.questionGate -ne $false -or $hostContract.executionCadence.humanPhaseGate -ne $false -or $hostContract.executionCadence.autonomousUntilBoundary -ne $true -or $hostContract.executionCadence.reflectedNextSeedAutoAdmit -ne $true){throw 'continuous execution cadence mismatch'}

$iContext=Get-Content -LiteralPath (Join-Path $root '.pmcro/protocol/i-context.schema.json') -Raw|ConvertFrom-Json
if($iContext.properties.schema.const -ne 'pmcro.i-context/v1'){throw 'I-context schema mismatch'}
if($iContext.properties.consciousnessClaim.const -ne $false){throw 'I-context consciousness law mismatch'}
if('addressedIRef' -notin @($iContext.required)){throw 'I-context addressedIRef missing'}

$requiredPhrases=@('I AM the Orchestrator.','I AM the Planner.','I AM the Maker.','I AM the Checker.','I AM the Reflector.','Projection is not activation.','Never ask the human to invoke the next phase','resume from durable queue/trail state')
foreach($hostName in @($hostContract.requiredProjectedHosts)){
  $hostRoot=Join-Path $root $hostName
  foreach($rel in @('catalog.json','project.json','routing.json','grants.json','lifecycle.json')){if(-not(Test-Path -LiteralPath (Join-Path $hostRoot $rel) -PathType Leaf)){throw "$hostName missing $rel"}}
  $activation=Join-Path $hostRoot 'ACTIVATE.md'
  if(-not(Test-Path -LiteralPath $activation -PathType Leaf)){throw "$hostName missing ACTIVATE.md"}
  $text=Get-Content -LiteralPath $activation -Raw
  foreach($phrase in $requiredPhrases){if(-not $text.Contains($phrase)){throw "$hostName activation missing phrase: $phrase"}}
  if(-not $text.Contains("$hostName -> .agents -> .pmcro")){throw "$hostName activation authority chain mismatch"}
}

'REPOSITORY-TEMPLATE-PASS'
return
