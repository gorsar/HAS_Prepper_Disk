# config\content.conf içindeki ZIM dosyalarının en yeni sürümünü indirir.
# Downloads the newest version of each ZIM listed in config\content.conf.
# Yarıda kalırsa tekrar çalıştır, kaldığı yerden devam eder. / Re-run to resume.
param([string]$Conf)
. "$PSScriptRoot\common.ps1"
$ErrorActionPreference = 'Continue'

if (-not $Conf) { $Conf = Join-Path $RepoRoot 'config\content.conf' }
if (-not (Test-Path $KiwixManage)) { & "$PSScriptRoot\setup.ps1" }
New-Item -ItemType Directory -Force $ZimDir | Out-Null
$Base = 'https://download.kiwix.org/zim'

Say "ZIM klasörü / folder: $ZimDir" Cyan
$failed = $false
foreach ($line in Get-Content -Encoding UTF8 $Conf) {
  $l = $line.Trim()
  if ($l -eq '' -or $l.StartsWith('#')) { continue }
  $parts = $l -split '\s+'
  if ($parts.Count -lt 2) { continue }
  $folder, $prefix = $parts[0], $parts[1]

  $listing = (& curl.exe -fsSL "$Base/$folder/") -join "`n"
  $pattern = [regex]::Escape($prefix) + '_\d{4}-\d{2}[a-z]?\.zim'
  $latest = [regex]::Matches($listing, $pattern) | ForEach-Object Value | Sort-Object -Unique | Select-Object -Last 1
  if (-not $latest) { Say "!! $prefix bulunamadı / not found in $Base/$folder/" Yellow; $failed = $true; continue }

  $target = Join-Path $ZimDir $latest
  if (Test-Path $target) { Say "== $latest zaten var / already present"; continue }

  $drive = Get-PSDrive -Name ($ZimDir.Substring(0,1)) -ErrorAction SilentlyContinue
  $free = if ($drive) { ' (boş alan / free: {0:N1} GB)' -f ($drive.Free / 1GB) } else { '' }
  Say ">> $latest indiriliyor / downloading$free" Cyan
  & curl.exe -fL -C - --retry 5 --retry-delay 10 -o "$target.part" "$Base/$folder/$latest"
  if ($LASTEXITCODE -eq 0) {
    Move-Item -Force "$target.part" $target
    Say "OK $latest tamamlandı / done" Green
    # Eski sürümleri sil / remove older versions of the same ZIM
    Get-ChildItem $ZimDir -Filter "$($prefix)_*.zim" -File |
      Where-Object { $_.Name -ne $latest -and $_.Name -match ('^' + $pattern + '$') } |
      ForEach-Object { Say "-- eski sürüm siliniyor / removing $($_.Name)"; Remove-Item -Force $_.FullName }
  } else {
    Say "!! $latest indirilemedi / download failed (tekrar çalıştır / re-run to resume)" Red; $failed = $true
  }
}

Update-KiwixLibrary
if ($failed) { exit 1 }
