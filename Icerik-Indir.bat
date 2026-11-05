@echo off
rem config\content.conf icindeki ZIM dosyalarini indirir / downloads the ZIMs in config\content.conf
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\download-content.ps1" %*
pause
