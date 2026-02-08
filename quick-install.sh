#!/usr/bin/env bash
# OpenClaw Quick Install - 快速安装脚本
# 只安装最核心的 Skills

set -euo pipefail

echo "🦞 OpenClaw Quick Install"
echo "========================"

# 安装 OpenClaw (如果未安装)
if ! command -v openclaw &> /dev/null; then
    echo "📦 安装 OpenClaw..."
    npm install -g openclaw@latest
fi

# 创建目录
mkdir -p ~/.openclaw/workspace/{skills,scripts,memory}

# 核心 Skills 列表
CORE_SKILLS=(
    "coding-agent"
    "github"
    "weather"
    "nano-pdf"
    "openai-whisper"
    "things-mac"
    "skill-creator"
)

echo ""
echo "📦 安装核心 Skills..."
for skill in "${CORE_SKILLS[@]}"; do
    echo -n "  $skill... "
    npx clawhub@latest install "$skill" --force 2>/dev/null && echo "✅" || echo "⚠️"
done

# 浏览器自动化
echo ""
echo "🌐 安装浏览器自动化..."
if ! command -v agent-browser &> /dev/null; then
    npm install -g agent-browser 2>/dev/null && echo "  agent-browser ✅" || echo "  agent-browser ⚠️"
fi

# 快捷脚本
cat > ~/.openclaw/workspace/scripts/status.sh << 'EOF'
#!/usr/bin/env bash
echo "🦞 OpenClaw Status"
echo "=================="
echo "Skills: $(ls ~/.openclaw/workspace/skills/ 2>/dev/null | wc -l)"
echo "Scripts: $(ls ~/.openclaw/workspace/scripts/*.sh 2>/dev/null | wc -l)"
openclaw status 2>/dev/null || echo "Gateway: 未运行"
EOF
chmod +x ~/.openclaw/workspace/scripts/status.sh

echo ""
echo "✅ 安装完成！"
echo ""
echo "📁 位置: ~/.openclaw/workspace/"
echo "📦 Skills: ~/.openclaw/workspace/skills/"
echo "🛠️ 脚本: ~/.openclaw/workspace/scripts/"
echo ""
echo "💡 使用: openclaw --help"
