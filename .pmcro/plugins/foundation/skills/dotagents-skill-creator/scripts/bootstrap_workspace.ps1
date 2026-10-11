param(
  [Parameter(Mandatory=$true)][string]$Root,
  [Parameter(Mandatory=$true)][string]$Skill,
  [string]$Plugin = "pmcro",
  [switch]$Apply
)
$ErrorActionPreference = "Stop"
if ($Skill -notmatch "^[a-z0-9]+(?:-[a-z0-9]+)*$") { throw "Skill must be kebab-case" }
$workspace = (Resolve-Path -LiteralPath $Root).Path
$skillPath = Join-Path $workspace ".agents\skills\$Skill"
$paths = @(
  $skillPath,
  (Join-Path $skillPath "agents"),
  (Join-Path $skillPath "scripts"),
  (Join-Path $skillPath "references"),
  (Join-Path $skillPath "assets"),
  (Join-Path $skillPath "tests")
)
if (-not $Apply) {
  [pscustomobject]@{
    status = "SIMULATED"
    plugin = $Plugin
    skill = $Skill
    paths = $paths
    next = "rerun with -Apply after independent review"
  } | ConvertTo-Json -Depth 4
  exit 0
}
if (Test-Path -LiteralPath $skillPath) { throw "refusing to overwrite existing skill: $skillPath" }
$paths | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
@"
---
name: $Skill
description: Generated child skill; complete the contract before promotion.
---

# $Skill

This is a staged child skill. Add the domain contract, references, scripts,
assets, tests, and sample prompts before requesting an independent checker.
"@ | Set-Content -LiteralPath (Join-Path $skillPath "SKILL.md") -Encoding UTF8
@"
display_name: $Skill
short_description: Generated child skill
default_prompt: |
  Inspect the requested domain and return a bounded PMCR-O artifact.
sample_prompts_ref: "references/sample-prompts.md"
independent_surface: true
independent_checker: false
"@ | Set-Content -LiteralPath (Join-Path $skillPath "agents\openai.yaml") -Encoding UTF8
('{\"id\":\"' + $Skill + '\",\"version\":\"0.1.0\",\"role\":\"skill\",\"independentSurface\":true,\"independentChecker\":false}') |
  Set-Content -LiteralPath (Join-Path $skillPath "agents\$Skill.json") -Encoding UTF8
("### Create a new " + $Skill + [Environment]::NewLine + [Environment]::NewLine + "Run a dry-run and return the artifact path.") |
  Set-Content -LiteralPath (Join-Path $skillPath "references\sample-prompts.md") -Encoding UTF8
"Add domain references and executable validation here." |
  Set-Content -LiteralPath (Join-Path $skillPath "assets\README.md") -Encoding UTF8
Write-Output "CREATED: $skillPath"
