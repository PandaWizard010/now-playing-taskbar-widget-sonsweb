# Build an unsigned MSIX for the independent Sonos fork.
#
# For sideloading, sign with your own certificate matching the manifest Publisher.
# For Store submission, first reserve your own product and use its identity.
#
# Uso:  powershell -ExecutionPolicy Bypass -File Packaging\build-msix.ps1
# Output: Packaging\out\SonosTaskbarWidget.msix (unsigned).

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$staging = Join-Path $PSScriptRoot "staging"
$out = Join-Path $PSScriptRoot "out"

# 1. Publish self-contained; LICENSE and NOTICE.md are copied by the project.
Write-Host "== dotnet publish (self-contained) =="
$dotnet = "C:\Program Files\dotnet\dotnet.exe"
if (-not (Test-Path $dotnet)) { $dotnet = "dotnet" }
if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
& $dotnet publish (Join-Path $root "SpotifyTaskbarWidget.csproj") -c Release `
    -o $staging -p:SelfContained=true -p:PublishSingleFile=false --nologo
if ($LASTEXITCODE -ne 0) { throw "publish falhou" }

# 2. Manifesto + assets
Copy-Item (Join-Path $PSScriptRoot "AppxManifest.xml") $staging -Force
Copy-Item (Join-Path $PSScriptRoot "Assets") (Join-Path $staging "Assets") -Recurse -Force
$manifest = Get-Content (Join-Path $staging "AppxManifest.xml") -Raw
if ($manifest -match 'Publisher="CN=PandaWizard010"') {
    Write-Warning "Local fork identity: sign with your own matching certificate. Store submission requires your own reserved product identity."
}

# 3. makeappx (SDK BuildTools via NuGet, sem instalar o Windows SDK completo)
$tools = Join-Path $PSScriptRoot "sdk-tools"
$makeappx = Get-ChildItem $tools -Recurse -Filter makeappx.exe -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match "x64" } | Select-Object -First 1
if (-not $makeappx) {
    Write-Host "== a obter Microsoft.Windows.SDK.BuildTools (NuGet) =="
    $nupkg = Join-Path $env:TEMP "sdk-buildtools.zip"
    Invoke-WebRequest "https://www.nuget.org/api/v2/package/Microsoft.Windows.SDK.BuildTools" -OutFile $nupkg
    Expand-Archive $nupkg $tools -Force
    $makeappx = Get-ChildItem $tools -Recurse -Filter makeappx.exe |
        Where-Object { $_.FullName -match "x64" } | Select-Object -First 1
}

# 4. Empacotar
New-Item -ItemType Directory -Force $out | Out-Null
$msix = Join-Path $out "SonosTaskbarWidget.msix"
if (Test-Path $msix) { Remove-Item $msix -Force }
& $makeappx.FullName pack /d $staging /p $msix /o
if ($LASTEXITCODE -ne 0) { throw "makeappx falhou" }
Write-Host "OK: $msix ($([math]::Round((Get-Item $msix).Length/1MB,1)) MB)"
Write-Host "Unsigned fork package created. See docs/store-listing.md for signing and distribution."
