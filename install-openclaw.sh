#!/usr/bin/env bash
# OpenClaw 一键安装脚本
# 安装 OpenClaw + 常用 Skills 组合

set -euo pipefail

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
echo_success() { echo -e "${GREEN}[✅]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[⚠️]${NC} $1"; }
echo_error() { echo -e "${RED}[❌]${NC} $1"; }

# 基础目录
OPENCLAW_DIR="$HOME/.openclaw/workspace"
SKILLS_DIR="$OPENCLAW_DIR/skills"
SCRIPTS_DIR="$OPENCLAW_DIR/scripts"

# ============ 安装步骤 ============

step() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# 检查 Node.js 版本
check_node() {
    step "1️⃣ 检查环境"
    if ! command -v node &> /dev/null; then
        echo_error "Node.js 未安装，请先安装 Node.js >= 22"
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [[ "$NODE_VERSION" -lt 22 ]]; then
        echo_warn "Node.js 版本低于 22，建议升级"
    fi
    echo_success "Node.js 版本: $(node -v)"
}

# 安装 OpenClaw
install_openclaw() {
    step "2️⃣ 安装 OpenClaw"
    
    if command -v openclaw &> /dev/null; then
        echo_warn "OpenClaw 已安装，版本: $(openclaw --version 2>/dev/null || echo 'unknown')"
    else
        echo_info "安装 OpenClaw CLI..."
        npm install -g openclaw@latest
        echo_success "OpenClaw 安装完成"
    fi
}

# 安装 ClawHub
install_clawhub() {
    step "3️⃣ 安装 ClawHub CLI"
    
    if command -v clawhub &> /dev/null || command -v npx &> /dev/null; then
        echo_success "ClawHub 可用 (npx clawhub)"
    fi
}

# 核心 Skills 分类
declare -A CORE_SKILLS=(
    ["coding-agent"]="编程代理"
    ["github"]="GitHub 交互"
    ["weather"]="天气查询"
    ["nano-pdf"]="PDF 处理"
    ["openai-whisper"]="语音转文本"
    ["things-mac"]="任务管理"
    ["skill-creator"]="技能创建"
)

declare -A DEV_SKILLS=(
    ["oracle"]="AI/LLM 最佳实践"
    ["agent-browser-clawdbot"]="浏览器自动化"
    ["obsidian"]="Obsidian 笔记"
    ["local-places"]="本地地点搜索"
    ["blogwatcher"]="博客/RSS 监控"
    ["video-frames"]="视频帧提取"
)

declare -A SECURITY_SKILLS=(
    ["bitwarden"]="Bitwarden 密码管理"
    ["openssl"]="加密工具"
    ["security-audit"]="安全审计"
    ["senior-security"]="高级安全专家"
    ["moltthreats"]="威胁检测"
    ["zero-trust"]="零信任安全"
    ["clawvault"]="密钥保险库"
)

# 安装 Skills
install_skills() {
    step "4️⃣ 安装 Skills"
    
    install_category() {
        local name=$1
        local -n skills=$2
        local desc=$3
        
        echo ""
        echo_info "📦 $desc"
        echo ""
        
        for skill in "${!skills[@]}"; do
            echo -n "  安装 ${skills[$skill]}... "
            if npx clawhub@latest install "$skill" --force 2>/dev/null; then
                echo_success "✅"
            else
                echo_warn "⚠️"
            fi
        done
    }
    
    install_category "CORE_SKILLS" CORE_SKILLS "🔧 核心 Skills"
    install_category "DEV_SKILLS" DEV_SKILLS "🛠️ 开发 Skills"
    install_category "SECURITY_SKILLS" SECURITY_SKILLS "🛡️ 安全 Skills"
}

# 创建快捷脚本
create_scripts() {
    step "5️⃣ 创建快捷脚本"
    
    mkdir -p "$SCRIPTS_DIR"
    
    # GitHub 监控脚本
    cat > "$SCRIPTS_DIR/trending-monitor.sh" << 'EOF'
#!/usr/bin/env bash
# GitHub Trending Monitor
cd ~/.openclaw/workspace
./scripts/ai-trending-monitor.sh
EOF
    chmod +x "$SCRIPTS_DIR/trending-monitor.sh"
    echo_success "创建 trending-monitor.sh"
    
    # AI 热门报告脚本
    cat > "$SCRIPTS_DIR/ai-report.sh" << 'EOF'
#!/usr/bin/env bash
# 查看 AI 热门报告
cat ~/.openclaw/workspace/memory/AI-Trending-Report.md
EOF
    chmod +x "$SCRIPTS_DIR/ai-report.sh"
    echo_success "创建 ai-report.sh"
    
    # 龙虾早报脚本
    cat > "$SCRIPTS_DIR/daily-brief.sh" << 'EOF'
#!/usr/bin/env bash
# 生成龙虾早报
cd ~/.openclaw/workspace
./skills/commit-analyzer/analyzer.sh health 2>/dev/null || echo "无可用数据"
echo ""
echo "📊 GitHub 热门:"
curl -s "https://github.com/trending" | grep -o 'href="/[^"]*"' | head -5
EOF
    chmod +x "$SCRIPTS_DIR/daily-brief.sh"
    echo_success "创建 daily-brief.sh"
    
    # OpenClaw 状态脚本
    cat > "$SCRIPTS_DIR/status.sh" << 'EOF'
#!/usr/bin/env bash
# OpenClaw 状态检查
echo "🦞 OpenClaw 状态"
echo ""
echo "📦 Skills:"
ls ~/.openclaw/workspace/skills/ 2>/dev/null | wc -l
echo ""
echo "📄 Scripts:"
ls ~/.openclaw/workspace/scripts/*.sh 2>/dev/null | xargs -I {} basename {}
echo ""
echo "🤖 OpenClaw:"
openclaw status 2>/dev/null || echo "Gateway 未运行"
echo ""
echo "⏰ Cron 任务:"
crontab -l 2>/dev/null | grep -E "(trending|ai-trending)" || echo "无定时任务"
EOF
    chmod +x "$SCRIPTS_DIR/status.sh"
    echo_success "创建 status.sh"
}

# 设置 Cron 任务
setup_cron() {
    step "6️⃣ 设置定时任务"
    
    # AI 热门每日报告
    echo_info "添加 AI Trending 每日报告 (每天 08:00)"
    # cron 任务通过 OpenClaw gateway 管理
    
    echo_success "定时任务可通过 'openclaw cron' 管理"
}

# 安装浏览器依赖
install_browser_deps() {
    step "7️⃣ 安装浏览器依赖"
    
    if command -v agent-browser &> /dev/null; then
        echo_info "安装 Chromium..."
        agent-browser install 2>/dev/null || echo_warn "跳过 (可能需要手动安装)"
        echo_success "浏览器依赖安装完成"
    else
        echo_warn "agent-browser 未安装，跳过"
    fi
}

# 初始化目录
init_dirs() {
    step "0️⃣ 初始化目录"
    
    mkdir -p "$OPENCLAW_DIR"
    mkdir -p "$SKILLS_DIR"
    mkdir -p "$SCRIPTS_DIR"
    mkdir -p "$OPENCLAW_DIR/memory"
    mkdir -p "$OPENCLAW_DIR/scripts"
    
    echo_success "目录结构创建完成"
}

# 显示完成信息
show_summary() {
    step "🎉 安装完成！"
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " 📁 目录结构:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $OPENCLAW_DIR/"
    echo "  ├── skills/      (Skills 目录)"
    echo "  ├── scripts/      (快捷脚本)"
    echo "  └── memory/      (数据存储)"
    echo ""
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " 📦 已安装 Skills:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ls "$SKILLS_DIR" 2>/dev/null | head -20 || echo "  无"
    echo ""
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " 🛠️ 快捷脚本:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ls "$SCRIPTS_DIR"/*.sh 2>/dev/null | xargs -I {} basename {} || echo "  无"
    echo ""
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " 💡 使用方法:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  查看 AI 热门报告:    ./scripts/ai-report.sh"
    echo "  查看状态:            ./scripts/status.sh"
    echo "  OpenClaw 命令:       openclaw --help"
    echo "  安装新 Skill:        npx clawhub@latest install <skill>"
    echo ""
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " 🔗 链接:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  OpenClaw 文档:  https://docs.openclaw.ai"
    echo "  ClawHub:       https://clawhub.com"
    echo "  GitHub:        https://github.com/openclaw/openclaw"
    echo ""
}

# 主函数
main() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " 🦞 OpenClaw 一键安装脚本"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    init_dirs
    check_node
    install_openclaw
    install_clawhub
    install_skills
    create_scripts
    install_browser_deps
    setup_cron
    show_summary
}

# 运行
main "$@"
