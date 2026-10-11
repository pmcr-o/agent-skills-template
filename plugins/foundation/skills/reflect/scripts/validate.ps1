param()
$ErrorActionPreference = "Stop"
$skillRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
foreach ($relative in @("SKILL.md","agents\openai.yaml","references\sample-prompts.md","assets\README.md")) {
  $path = Join-Path $skillRoot $relative
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "missing $path" }
}
$jsonFiles = @(Get-ChildItem (Join-Path $skillRoot "agents") -Filter *.json -File)
if ($jsonFiles.Count -ne 1) { throw "expected one agent json" }
$surface = Get-Content $jsonFiles[0].FullName -Raw | ConvertFrom-Json
if ($surface.independentSurface -ne $true) { throw "independentSurface must be true" }
$prompts = Get-Content (Join-Path $skillRoot "references\sample-prompts.md") -Raw
$count = ([regex]::Matches($prompts, "(?m)^### ")).Count
if ($count -lt 1 -or $count -gt 5) { throw "sample prompt count must be one to five" }
Write-Output "PASS: $((Split-Path $skillRoot -Leaf))"
