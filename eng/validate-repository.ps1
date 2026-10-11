param()
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$required=@('AGENTS.md','.pmcro/protocol/i-context.schema.json','.pmcro/protocol/host-activation.json','.agents/catalog.json','.agents/project.json','.agents/routing.json','.agents/grants.json','.agents/lifecycle.json')
foreach($rel in $required){if(-not(Test-Path -LiteralPath (Join-Path $root $rel) -PathType Leaf)){throw "missing $rel"}}
$hostContract=Get-Content -LiteralPath (Join-Path $root '.pmcro/protocol/host-activation.json') -Raw|ConvertFrom-Json
if($hostContract.rootSeedPhase -ne 'ORCHESTRATE'){throw 'host activation must begin at ORCHESTRATE'}
if($hostContract.activation.projectionAloneIsActivation -ne $false){throw 'projection may not equal activation'}
if($hostContract.authorityCeiling.rule -ne 'inherit-or-narrow-never-widen'){throw 'authority ceiling law missing'}
if($hostContract.checker.independent -ne $true -or $hostContract.checker.makerMaySelfApprove -ne $false){throw 'independent checker law missing'}
$iContext=Get-Content -LiteralPath (Join-Path $root '.pmcro/protocol/i-context.schema.json') -Raw|ConvertFrom-Json
if($iContext.properties.schema.const -ne 'pmcro.i-context/v1'){throw 'I-context schema mismatch'}
if($iContext.properties.consciousnessClaim.const -ne $false){throw 'I-context consciousness law mismatch'}
foreach($hostName in @('.claude','.grok','.cursor','.github')){
  $hostRoot=Join-Path $root $hostName
  foreach($rel in @('catalog.json','project.json','routing.json','grants.json','lifecycle.json')){if(-not(Test-Path -LiteralPath (Join-Path $hostRoot $rel) -PathType Leaf)){throw "$hostName missing $rel"}}
}
'REPOSITORY-TEMPLATE-PASS'
return
