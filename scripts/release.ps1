<#
.SYNOPSIS
  Build, tag, and publish an Open Budget release.

.DESCRIPTION
  Runs analyze + tests, builds a release APK with JDK 17, renames it
  OpenBudget-v<version>.apk, creates a git tag, and (optionally) publishes
  a GitHub release with RELEASE_NOTES_v<version>.md as the body.

.PARAMETER Version
  Semantic version (e.g. 1.0.1). Defaults to the value in pubspec.yaml.

.PARAMETER SkipTests
  Skip flutter analyze + test.

.PARAMETER Publish
  After building, create git tag, push, and `gh release create`.

.EXAMPLE
  pwsh scripts/release.ps1
  pwsh scripts/release.ps1 -Version 1.0.1 -Publish
#>
[CmdletBinding()]
param(
  [string]$Version,
  [switch]$SkipTests,
  [switch]$Publish
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function Get-PubspecVersion {
  $line = Select-String -Path 'pubspec.yaml' -Pattern '^version:\s*(\S+)' | Select-Object -First 1
  if (-not $line) { throw "version: not found in pubspec.yaml" }
  return ($line.Matches[0].Groups[1].Value -split '\+')[0]
}

if (-not $Version) { $Version = Get-PubspecVersion }
Write-Host "==> Open Budget release v$Version" -ForegroundColor Cyan

# JDK 17 (Gradle 8.5 does not support JDK 25).
if (-not $env:JAVA_HOME -or -not (Test-Path "$env:JAVA_HOME\bin\javac.exe")) {
  $candidates = @(
    'C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot',
    'C:\Program Files\Eclipse Adoptium\jdk-17'
  )
  $env:JAVA_HOME = $candidates | Where-Object { Test-Path "$_\bin\javac.exe" } | Select-Object -First 1
  if (-not $env:JAVA_HOME) { throw "JDK 17 not found. Set JAVA_HOME to a JDK 17 install." }
}
Write-Host "JAVA_HOME = $env:JAVA_HOME"

if (-not $SkipTests) {
  Write-Host "==> flutter analyze" -ForegroundColor Cyan
  flutter analyze
  if ($LASTEXITCODE -ne 0) { throw "flutter analyze failed" }

  Write-Host "==> flutter test" -ForegroundColor Cyan
  flutter test
  if ($LASTEXITCODE -ne 0) { throw "flutter test failed" }
}

Write-Host "==> flutter build apk --release" -ForegroundColor Cyan
flutter build apk --release
if ($LASTEXITCODE -ne 0) { throw "flutter build apk failed" }

$src = Join-Path $root 'build\app\outputs\flutter-apk\app-release.apk'
$dst = Join-Path $root "OpenBudget-v$Version.apk"
Copy-Item $src $dst -Force
Write-Host "==> $dst" -ForegroundColor Green

$notes = Join-Path $root "RELEASE_NOTES_v$Version.md"
if (-not (Test-Path $notes)) {
  Write-Warning "No $notes — skipping GitHub release body."
}

if (-not $Publish) {
  Write-Host "`nDone. Re-run with -Publish to tag, push, and `gh release create`." -ForegroundColor Yellow
  return
}

$tag = "v$Version"
if (git tag --list $tag) {
  Write-Warning "Tag $tag already exists."
} else {
  git tag -a $tag -m "Open Budget $tag"
  git push origin $tag
}

$args = @('release', 'create', $tag, $dst, '--title', "Open Budget $tag")
if (Test-Path $notes) { $args += @('--notes-file', $notes) } else { $args += @('--generate-notes') }
gh @args
if ($LASTEXITCODE -ne 0) { throw "gh release create failed" }
Write-Host "==> Released $tag" -ForegroundColor Green
