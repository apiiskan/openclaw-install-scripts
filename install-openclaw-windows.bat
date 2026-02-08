@echo off
REM OpenClaw Windows 一键安装
echo 🚀 OpenClaw 安装中...

REM 下载脚本
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/apiiskan/openclaw-install-scripts/main/install-openclaw-windows.ps1' -OutFile '%TEMP%\install.ps1'"

REM 运行安装 (自动输入 API Key)
echo %GEMINI_API_KEY% | powershell -Command "$key = Read-Host 'GEMINI_API_KEY'; $content = Get-Content '%TEMP%\install.ps1'; $content = $content -replace 'Read-Host \"GEMINI_API_KEY\"', '\"' + $key + '\"'; $content | Out-File '%TEMP%\install.ps1' -Encoding UTF8; & '%TEMP%\install.ps1'"

pause
