# HAS_PrepperDisk (Windows): ortak ayarlar / shared settings.
# Diğer betikler bu dosyayı içe alır. / Dot-sourced by the other scripts.

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$BinDir   = Join-Path $PSScriptRoot 'bin'

# config/windows.conf  (KEY=VALUE satırları / lines). Varsayılanlar / defaults:
$Settings = @{
  LIBRARY    = (Join-Path $RepoRoot 'library')
  PORT       = '8080'
  KIWIX_PORT = '8081'
}
$ConfFile = Join-Path $RepoRoot 'config\windows.conf'
if (Test-Path $ConfFile) {
  foreach ($line in Get-Content -Encoding UTF8 $ConfFile) {
    $l = $line.Trim()
    if ($l -eq '' -or $l.StartsWith('#')) { continue }
    $k, $v = $l -split '=', 2
    if ($v) { $Settings[$k.Trim().ToUpper()] = $v.Trim().Trim('"') }
  }
}

$Library     = [IO.Path]::GetFullPath($Settings.LIBRARY)
$ZimDir      = Join-Path $Library 'zims'
$LibraryXml  = Join-Path $Library 'library.xml'

# Sürümler / versions
$KiwixVersion = '3.8.1'
$CaddyVersion = '2.11.9'
$KiwixUrl = "https://download.kiwix.org/release/kiwix-tools/kiwix-tools_win-x86_64-$KiwixVersion.zip"
$CaddyUrl = "https://github.com/caddyserver/caddy/releases/download/v$CaddyVersion/caddy_${CaddyVersion}_windows_amd64.zip"

$KiwixServe  = Join-Path $BinDir 'kiwix\kiwix-serve.exe'
$KiwixManage = Join-Path $BinDir 'kiwix\kiwix-manage.exe'
$Caddy       = Join-Path $BinDir 'caddy\caddy.exe'

function Say($msg, $color = 'Gray') { Write-Host $msg -ForegroundColor $color }

# library.xml dosyasını klasördeki ZIM'lerden yeniden oluşturur.
# Rebuilds library.xml from the ZIM files in the folder.
function Update-KiwixLibrary {
  New-Item -ItemType Directory -Force $ZimDir | Out-Null
  $tmp = "$LibraryXml.new"
  Set-Content -Encoding UTF8 $tmp '<library version="20110515"></library>'
  $zims = @(Get-ChildItem -Path $ZimDir -Filter *.zim -File | Sort-Object Name)
  foreach ($z in $zims) {
    & $KiwixManage $tmp add $z.FullName | Out-Null
    if ($LASTEXITCODE -ne 0) { Say "!! $($z.Name) kütüphaneye eklenemedi / could not be added (bozuk olabilir / may be corrupt)" Yellow }
  }
  Move-Item -Force $tmp $LibraryXml
  Say ">> Kütüphane: $($zims.Count) ZIM / library: $($zims.Count) ZIM files"
}
