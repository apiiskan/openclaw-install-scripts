# OpenClaw Windows 一键安装脚本 (PowerShell)
# 需要以管理员身份运行 PowerShell

# 颜色输出
$Green = [ConsoleColor]::Green
$Yellow = [ConsoleColor]::Yellow
$Blue = [ConsoleColor]::Blue
$Red = [ConsoleColor]::Red
$White = [ConsoleColor]::White

function Write-Info { Write-Host "[INFO] $args" -ForegroundColor $Blue }
function Write-Success { Write-Host "[✅] $args" -ForegroundColor $Green }
function Write-Warn { Write-Host "[⚠️] $args" -ForegroundColor $Yellow }
function Write-Error { Write-Host "[❌] $args" -ForegroundColor $Red }

# 基础目录
$OpenClawDir = "$env:USERPROFILE\.openclaw\workspace"
$SkillsDir = "$OpenClawDir\skills"
$ScriptsDir = "$OpenClawDir\scripts"
$MemoryDir = "$OpenClawDir\memory"

# ============ 安装步骤 ============

function Step {
    param([string]$Name)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host " $Name" -ForegroundColor $White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
}

# 检查环境
function Check-Environment {
    Step -Name "1️⃣ 检查环境"
    
    # 检查 Node.js
    try {
        $nodeVersion = node --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Node.js 未安装，请先安装 Node.js >= 22"
            Write-Info "下载地址: https://nodejs.org"
            exit 1
        }
        $majorVersion = $nodeVersion.Replace('v','').Split('.')[0]
        if ([int]$majorVersion -lt 22) {
            Write-Warn "Node.js 版本低于 22，建议升级"
        }
        Write-Success "Node.js 版本: $nodeVersion"
    } catch {
        Write-Error "Node.js 未安装，请先安装 Node.js >= 22"
        exit 1
    }
    
    # 检查 Windows 版本
    Write-Success "Windows 版本: $(Get-CimInstance -ClassName Win32_OperatingSystem -Property Caption).Caption"
}

# 安装 OpenClaw
function Install-OpenClaw {
    Step -Name "2️⃣ 安装 OpenClaw"
    
    try {
        $openclawVersion = openclaw --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Warn "OpenClaw 已安装，版本: $openclawVersion"
        } else {
            Write-Info "安装 OpenClaw CLI..."
            npm install -g openclaw@latest
            Write-Success "OpenClaw 安装完成"
        }
    } catch {
        Write-Info "安装 OpenClaw CLI..."
        npm install -g openclaw@latest
        Write-Success "OpenClaw 安装完成"
    }
}

# 安装 Skills
function Install-Skills {
    Step -Name "3️⃣ 安装 Skills"
    
    # 核心 Skills
    $coreSkills = @(
        "coding-agent",
        "github",
        "weather",
        "nano-pdf",
        "openai-whisper",
        "things-mac",
        "skill-creator"
    )
    
    Write-Host ""
    Write-Info "📦 安装核心 Skills..."
    foreach ($skill in $coreSkills) {
        Write-Host -NoNewline "  $skill... "
        try {
            npx clawhub@latest install $skill --force 2>$null | Out-Null
            Write-Host "✅" -ForegroundColor $Green
        } catch {
            Write-Host "⚠️" -ForegroundColor $Yellow
        }
    }
    
    # 开发 Skills
    $devSkills = @(
        "oracle",
        "agent-browser-clawdbot",
        "obsidian",
        "local-places",
        "blogwatcher"
    )
    
    Write-Host ""
    Write-Info "🛠️ 安装开发 Skills..."
    foreach ($skill in $devSkills) {
        Write-Host -NoNewline "  $skill... "
        try {
            npx clawhub@latest install $skill --force 2>$null | Out-Null
            Write-Host "✅" -ForegroundColor $Green
        } catch {
            Write-Host "⚠️" -ForegroundColor $Yellow
        }
    }
    
    # 安全 Skills
    $securitySkills = @(
        "bitwarden",
        "openssl",
        "security-audit",
        "senior-security",
        "zero-trust"
    )
    
    Write-Host ""
    Write-Info "🛡️ 安装安全 Skills..."
    foreach ($skill in $securitySkills) {
        Write-Host -NoNewline "  $skill... "
        try {
            npx clawhub@latest install $skill --force 2>$null | Out-Null
            Write-Host "✅" -ForegroundColor $Green
        } catch {
            Write-Host "⚠️" -ForegroundColor $Yellow
        }
    }
}

# 创建快捷脚本
function Create-Scripts {
    Step -Name "4️⃣ 创建快捷脚本"
    
    # 创建目录
    New-Item -ItemType Directory -Force -Path $ScriptsDir | Out-Null
    New-Item -ItemType Directory -Force -Path $MemoryDir | Out-Null
    
    # 状态脚本
    @'
@echo off
REM OpenClaw Status Script
echo 🦞 OpenClaw Status
echo ===================
echo.
echo Skills: %USERPROFILE%\.openclaw\workspace\skills\*
echo Scripts: %USERPROFILE%\.openclaw\workspace\scripts\*.bat
echo.
openclaw status 2>nul
echo.
echo ===================
'@ | Out-File -Encoding UTF8 "$ScriptsDir\status.bat" -Force
    
    # AI 热门报告脚本
    @'
@echo off
REM AI Trending Report Viewer
type %USERPROFILE%\.openclaw\workspace\memory\AI-Trending-Report.md
pause
'@ | Out-File -Encoding UTF8 "$ScriptsDir\ai-report.bat" -Force
    
    # 龙虾早报脚本
    @'
@echo off
REM Daily Brief Script
echo 🦞 龙虾早报
echo ===================
echo.
echo 📊 GitHub 热门:
curl -s "https://github.com/trending" 2>nul | findstr /c:"star" | head -5
echo.
echo 🌤️ 天气:
curl -s "wttr.in/Shanghai?format=3" 2>nul
echo.
echo ===================
pause
'@ | Out-File -Encoding UTF8 "$ScriptsDir\daily-brief.bat" -Force
    
    Write-Success "创建 status.bat"
    Write-Success "创建 ai-report.bat"
    Write-Success "创建 daily-brief.bat"
}

# 安装浏览器依赖
function Install-BrowserDeps {
    Step -Name "5️⃣ 安装浏览器依赖"
    
    try {
        $agentBrowserVersion = agent-browser --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "agent-browser 已安装"
        } else {
            Write-Info "安装 agent-browser..."
            npm install -g agent-browser
            Write-Info "运行 agent-browser install 安装 Chromium"
            agent-browser install 2>$null | Out-Null
            Write-Success "浏览器依赖安装完成"
        }
    } catch {
        Write-Warn "跳过浏览器依赖安装"
    }
}

# 显示完成信息
function Show-Summary {
    Step -Name "🎉 安装完成!"
    
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host " 📁 目录结构:" -ForegroundColor $White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host "  $OpenClawDir\"
    Write-Host "  ├── skills\      (Skills 目录)"
    Write-Host "  ├── scripts\     (快捷脚本 .bat)"
    Write-Host "  └── memory\      (数据存储)"
    Write-Host ""
    
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host " 📦 已安装 Skills:" -ForegroundColor $White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    
    $skillsCount = (Get-ChildItem -Path $SkillsDir -Directory -ErrorAction SilentlyContinue).Count
    Write-Host "  $skillsCount 个 Skills"
    Write-Host ""
    
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host " 🛠️ 快捷脚本:" -ForegroundColor $White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Get-ChildItem -Path "$ScriptsDir\*.bat" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "  $($_.Name)"
    }
    Write-Host ""
    
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host " 💡 使用方法:" -ForegroundColor $White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host "  查看状态:        双击 status.bat"
    Write-Host "  AI 热门报告:     双击 ai-report.bat"
    Write-Host "  龙虾早报:        双击 daily-brief.bat"
    Write-Host "  OpenClaw 命令:  openclaw --help"
    Write-Host "  安装新 Skill:    npx clawhub@latest install <skill>"
    Write-Host ""
    
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host " 🔗 链接:" -ForegroundColor $White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host "  OpenClaw 文档:  https://docs.openclaw.ai"
    Write-Host "  ClawHub:        https://clawhub.com"
    Write-Host "  GitHub:         https://github.com/openclaw/openclaw"
    Write-Host ""
}

# 主函数
function Main {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host " 🦞 OpenClaw Windows 一键安装脚本" -ForegroundColor $White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $White
    Write-Host ""
    
    # 检查是否以管理员运行 (某些安装需要)
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warn "建议以管理员身份运行 PowerShell 以获得最佳兼容性"
    }
    
    Check-Environment
    Install-OpenClaw
    Install-Skills
    Create-Scripts
    Install-BrowserDeps
    Show-Summary
}

# 运行
Main
