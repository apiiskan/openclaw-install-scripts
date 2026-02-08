@echo off
REM OpenClaw Windows 一键安装脚本 (CMD/Bat)
REM 需要以管理员身份运行

chcp 65001 >nul
setlocal enabledelayedexpansion

REM 颜色定义
for %%I in (0 1 2 3 4 5 6 7 8 9 A B C D E F) do (
    if %%I==0 set "ESC=^^^[[0m"
    if %%I==A set "ESC=^^^[[32m"  &REM Green
    if %%I==B set "ESC=^^^[[34m"  &REM Blue
    if %%I==C set "ESC=^^^[[33m"  &REM Yellow
    if %%I==E set "ESC=^^^[[31m"  &REM Red
    if %%I==F set "ESC=^^^[[37m"  &REM White
)

set "Green=F"
set "Blue=B"
set "Yellow=C"
set "Red=E"
set "White=F"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🦞 OpenClaw Windows 一键安装脚本
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM 检查 Node.js
echo [INFO] 检查环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo [❌] Node.js 未安装，请先安装 Node.js ^>= 22
    echo [INFO] 下载地址: https://nodejs.org
    pause
    exit /b 1
)
for /f "delims=v" %%a in ('node --version') do set "NODE_VER=%%a"
echo [✅] Node.js 版本: %NODE_VER%

REM 安装 OpenClaw
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 2️⃣ 安装 OpenClaw
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
openclaw --version >nul 2>&1
if errorlevel 1 (
    echo [INFO] 安装 OpenClaw CLI...
    npm install -g openclaw@latest
    echo [✅] OpenClaw 安装完成
) else (
    echo [⚠️] OpenClaw 已安装
)

REM 创建目录
set "OPENCLAW_DIR=%USERPROFILE%\.openclaw\workspace"
set "SKILLS_DIR=%OPENCLAW_DIR%\skills"
set "SCRIPTS_DIR=%OPENCLAW_DIR%\scripts"
set "MEMORY_DIR=%OPENCLAW_DIR%\memory"

mkdir "%SKILLS_DIR%" 2>nul
mkdir "%SCRIPTS_DIR%" 2>nul
mkdir "%MEMORY_DIR%" 2>nul
echo [✅] 目录创建完成

REM 安装核心 Skills
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 3️⃣ 安装核心 Skills
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set "CORE_SKILLS=coding-agent github weather nano-pdf openai-whisper things-mac skill-creator"
for %%s in (%CORE_SKILLS%) do (
    echo [INFO] 安装 %%s...
    npx clawhub@latest install %%s --force >nul 2>&1
    if errorlevel 1 (
        echo [⚠️] %%s 安装失败
    ) else (
        echo [✅] %%s 安装完成
    )
)

REM 安装开发 Skills
echo.
set "DEV_SKILLS=oracle agent-browser-clawdbot obsidian local-places blogwatcher"
for %%s in (%DEV_SKILLS%) do (
    echo [INFO] 安装 %%s...
    npx clawhub@latest install %%s --force >nul 2>&1
    if errorlevel 1 (
        echo [⚠️] %%s 安装失败
    ) else (
        echo [✅] %%s 安装完成
    )
)

REM 安装安全 Skills
echo.
set "SECURITY_SKILLS=bitwarden openssl security-audit senior-security zero-trust"
for %%s in (%SECURITY_SKILLS%) do (
    echo [INFO] 安装 %%s...
    npx clawhub@latest install %%s --force >nul 2>&1
    if errorlevel 1 (
        echo [⚠️] %%s 安装失败
    ) else (
        echo [✅] %%s 安装完成
    )
)

REM 创建快捷脚本
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 4️⃣ 创建快捷脚本
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REM 状态脚本
(
    echo @echo off
    echo cls
    echo echo 🦞 OpenClaw Status
    echo echo =^==================^=
    echo echo.
    echo for %%%%f in ^(%USERPROFILE%\.openclaw\workspace\skills\*^) do echo [SKILL] %%%%~nxf
    echo echo.
    echo openclaw status 2^>nul
    echo echo.
    echo pause
) > "%SCRIPTS_DIR%\status.bat"

echo [✅] 创建 status.bat

REM AI 报告脚本
(
    echo @echo off
    echo type "%USERPROFILE%\.openclaw\workspace\memory\AI-Trending-Report.md" 2^>nul
    echo pause
) > "%SCRIPTS_DIR%\ai-report.bat"

echo [✅] 创建 ai-report.bat

REM 安装浏览器
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 5️⃣ 安装浏览器依赖
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

agent-browser --version >nul 2>&1
if errorlevel 1 (
    echo [INFO] 安装 agent-browser...
    npm install -g agent-browser >nul 2>&1
    echo [✅] agent-browser 安装完成
    echo [INFO] 请运行: agent-browser install
) else (
    echo [✅] agent-browser 已安装
)

REM 完成总结
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🎉 安装完成!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 📁 位置: %OPENCLAW_DIR%
echo 📦 Skills: %SKILLS_DIR%
echo 🛠️ Scripts: %SCRIPTS_DIR%
echo.
echo 💡 使用方法:
echo   查看状态:     双击 status.bat
echo   OpenClaw 命令: openclaw --help
echo   安装 Skill:    npx clawhub^@latest install ^&lt;skill^&gt;
echo.
pause
endlocal
