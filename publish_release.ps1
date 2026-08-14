param(
    [Parameter(Mandatory=$true)][string]$Version,
    [Parameter(Mandatory=$true)][string]$Package,
    [string]$Installer = "",
    [string]$Notes = "",
    [string]$Repository = "MexGymSoftware/mexgym-updates"
)

$ErrorActionPreference = "Stop"
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "Instala GitHub CLI e inicia sesión antes de publicar: https://cli.github.com/"
}
if (-not (Test-Path -LiteralPath $Package -PathType Leaf)) {
    throw "No existe el paquete indicado: $Package"
}
if ($Installer -and -not (Test-Path -LiteralPath $Installer -PathType Leaf)) {
    throw "No existe el instalador indicado: $Installer"
}
if (-not $Notes) {
    $Notes = Join-Path $PSScriptRoot "release-notes\v$Version.md"
}
if (-not (Test-Path -LiteralPath $Notes -PathType Leaf)) {
    throw "No existe el archivo de notas: $Notes"
}

$assets = @($Package)
if ($Installer) { $assets += $Installer }
gh release create "v$Version" @assets --repo $Repository --title "MexGym $Version" --notes-file $Notes --latest
if ($LASTEXITCODE -ne 0) { throw "GitHub no pudo crear la publicación." }
