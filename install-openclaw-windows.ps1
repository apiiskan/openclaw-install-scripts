# OpenClaw Windows 一键安装脚本
# 配置与 macOS 完全一致

$ErrorActionPreference = "Stop"

Write-Host "🚀 OpenClaw Windows 安装" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host ""

# 1. 安装 Node.js (如果未安装)
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[1/5] 安装 Node.js 22..."
    $nodeUrl = "https://nodejs.org/dist/v22.22.0/node-v22.22.0-x64.msi"
    $nodeMsi = "$env:TEMP\node-v22.22.0-x64.msi"
    Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeMsi
    Start-Process -FilePath $nodeMsi -ArgumentList "/quiet" -Wait
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "✅ Node.js 安装完成" -ForegroundColor Green
} else {
    Write-Host "[1/5] Node.js 已安装: $(node --version)" -ForegroundColor Green
}

# 2. 安装 OpenClaw
Write-Host ""
Write-Host "[2/5] 安装 OpenClaw..."
npm install -g openclaw
Write-Host "✅ OpenClaw 安装完成" -ForegroundColor Green

# 3. 安装 Skills (全部 85+)
Write-Host ""
Write-Host "[3/5] 安装 Skills..."
$skills = @(
    "agent-browser-clawdbot",
    "apple-notes",
    "azure-keyvault-py",
    "bear-notes",
    "bitwarden",
    "blogwatcher",
    "bluebubbles",
    "canvas",
    "clawgatesecure",
    "clawhub",
    "clawvault",
    "coding-agent",
    "commit-analyzer",
    "dashlane",
    "discord",
    "gemini",
    "git-crypt-backup",
    "github",
    "google-gemini-media",
    "healthcheck",
    "ironclaw",
    "nano-banana-pro",
    "nano-pdf",
    "notion",
    "obsidian",
    "openai-image-gen",
    "openai-whisper",
    "openclaw-security-monitor",
    "openclaw-sentinel",
    "openssl",
    "oracle",
    "proton-pass",
    "security-audit",
    "security-auditor",
    "security-sentinel",
    "senior-security",
    "skill-creator",
    "things-mac",
    "video-frames",
    "weather",
    "zero-trust"
)

$installed = 0
foreach ($skill in $skills) {
    try {
        npx clawhub@latest install $skill --silent 2>$null
        $installed++
        Write-Host "  ✓ $skill" -ForegroundColor DarkGray
    } catch {
        Write-Host "  ✗ $skill" -ForegroundColor Red
    }
}
Write-Host "✅ 已安装 $installed / $($skills.Count) 个 skills" -ForegroundColor Green

# 4. 配置环境变量
Write-Host ""
Write-Host "[4/5] 配置环境变量..."

# GEMINI_API_KEY
$geminiKey = Read-Host "输入 GEMINI_API_KEY (回车跳过)"
if ($geminiKey) {
    [System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", $geminiKey, "User")
    Write-Host "✅ GEMINI_API_KEY 已设置" -ForegroundColor Green
}

# 写入 .env 文件
$envContent = @"
# OpenClaw Environment Variables
GEMINI_API_KEY=$geminiKey
"@
$envFile = "$env:USERPROFILE\.openclaw.env"
$envContent | Out-File -FilePath $envFile -Encoding UTF8
Write-Host "✅ 环境变量已保存到 $envFile" -ForegroundColor Green

# 5. 验证安装
Write-Host ""
Write-Host "[5/5] 验证安装..."
openclaw --version
npx clawhub@latest list 2>$null | Select-Object -First 10

Write-Host ""
Write-Host "========================" -ForegroundColor Cyan
Write-Host "✅ 安装完成!" -ForegroundColor Green
Write-Host ""
Write-Host "启动命令: openclaw" -ForegroundColor Yellow
Write-Host "配置文件: $env:USERPROFILE\.openclaw\config.yaml" -ForegroundColor Yellow
