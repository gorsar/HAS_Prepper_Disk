@echo off
rem HAS_PrepperDisk'i baslatir / starts HAS_PrepperDisk on Windows
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\start.ps1" %*
if errorlevel 1 pause
