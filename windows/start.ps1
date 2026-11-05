# HAS_PrepperDisk'i Windows'ta başlatır: kiwix-serve + Caddy (ana sayfa).
# Starts HAS_PrepperDisk on Windows: kiwix-serve + Caddy (homepage).
param([switch]$NoBrowser)
. "$PSScriptRoot\common.ps1"

if (-not (Test-Path $KiwixServe) -or -not (Test-Path $Caddy)) { & "$PSScriptRoot\setup.ps1" }
Update-KiwixLibrary
if (-not (Get-ChildItem $ZimDir -Filter *.zim -File)) {
  Say "Henüz ZIM yok. Icerik-Indir.bat ile indir ya da .zim dosyalarını şuraya kopyala:" Yellow
  Say "No ZIM files yet. Run Icerik-Indir.bat or copy .zim files into:  $ZimDir" Yellow
}

$port = $Settings.PORT; $kport = $Settings.KIWIX_PORT
$env:PREPPER_PORT = $port
$env:KIWIX_PORT   = $kport
$env:PREPPER_WWW  = (Join-Path $RepoRoot 'www\home') -replace '\\', '/'

$procs = @()
try {
  $procs += Start-Process -FilePath $KiwixServe -NoNewWindow -PassThru -ArgumentList @(
    '--address', '127.0.0.1', '--port', $kport, '--urlRootLocation', '/kiwix',
    '--monitorLibrary', '--library', "`"$LibraryXml`"")
  $procs += Start-Process -FilePath $Caddy -NoNewWindow -PassThru -ArgumentList @(
    'run', '--config', "`"$(Join-Path $PSScriptRoot 'Caddyfile')`"", '--adapter', 'caddyfile')
  Start-Sleep -Seconds 2
  foreach ($p in $procs) { if ($p.HasExited) { throw "$($p.ProcessName) başlatılamadı / failed to start (port $port / $kport kullanımda olabilir / may be in use)" } }

  $url = "http://localhost:$port/home/"
  Say ""
  Say "HAS_PrepperDisk çalışıyor / is running:  $url" Green
  $ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress -notmatch '^(127\.|169\.254\.)' } | ForEach-Object IPAddress
  foreach ($ip in $ips) { Say "  Aynı ağdaki cihazlardan / from other devices:  http://${ip}:$port/home/" }
  Say "Kapatmak için bu pencereyi kapat ya da Ctrl+C / close this window or press Ctrl+C to stop" DarkGray
  if (-not $NoBrowser) { Start-Process $url }

  while ($true) {
    Start-Sleep -Seconds 2
    foreach ($p in $procs) { if ($p.HasExited) { throw "$($p.ProcessName) beklenmedik şekilde kapandı / exited unexpectedly" } }
  }
} finally {
  foreach ($p in $procs) { if ($p -and -not $p.HasExited) { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue } }
}
