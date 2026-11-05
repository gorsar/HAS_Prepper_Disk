# kiwix-serve ve Caddy'yi windows\bin içine indirir (bir kez). / Downloads kiwix-serve and Caddy into windows\bin (once).
. "$PSScriptRoot\common.ps1"

function Install-Zip($name, $url, $dest, $exe) {
  if (Test-Path $exe) { Say "== $name zaten var / already installed"; return }
  Say ">> $name indiriliyor / downloading: $url" Cyan
  $tmp = Join-Path $env:TEMP ("prepper-" + [guid]::NewGuid() + '.zip')
  $ex  = "$tmp.d"
  try {
    & curl.exe -fL --retry 3 -o $tmp $url
    if ($LASTEXITCODE -ne 0) { throw "$name indirilemedi / download failed" }
    Expand-Archive -Force $tmp $ex
    New-Item -ItemType Directory -Force $dest | Out-Null
    # Zip içinde tek klasör varsa içeriğini al / flatten a single top-level folder
    $items = @(Get-ChildItem $ex)
    $src = if ($items.Count -eq 1 -and $items[0].PSIsContainer) { $items[0].FullName } else { $ex }
    Copy-Item -Recurse -Force (Join-Path $src '*') $dest
  } finally {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tmp, $ex
  }
  if (-not (Test-Path $exe)) { throw "$exe bulunamadı / not found after extracting" }
  Say "OK $name kuruldu / installed" Green
}

Install-Zip "Kiwix tools $KiwixVersion" $KiwixUrl (Join-Path $BinDir 'kiwix') $KiwixServe
Install-Zip "Caddy $CaddyVersion"       $CaddyUrl (Join-Path $BinDir 'caddy') $Caddy
New-Item -ItemType Directory -Force $ZimDir | Out-Null
