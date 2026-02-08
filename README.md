# 🦞 OpenClaw 一键安装脚本集合

![OpenClaw](https://img.shields.io/badge/OpenClaw-v2026.2.6-blue?style=flat-square&logo=openai)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-lightgrey?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

一键安装 OpenClaw 及其常用 Skills 的脚本集合，支持 macOS、Linux 和 Windows。

## 📦 包含内容

### 核心 Skills (7个)
- `coding-agent` - 编程代理
- `github` - GitHub 交互
- `weather` - 天气查询
- `nano-pdf` - PDF 处理
- `openai-whisper` - 语音转文本
- `things-mac` - 任务管理
- `skill-creator` - 技能创建

### 开发 Skills (5个)
- `oracle` - AI/LLM 最佳实践
- `agent-browser-clawdbot` - 浏览器自动化
- `obsidian` - Obsidian 笔记
- `local-places` - 本地地点搜索
- `blogwatcher` - 博客/RSS 监控

### 安全 Skills (5个)
- `bitwarden` - 密码管理
- `openssl` - 加密工具
- `security-audit` - 安全审计
- `senior-security` - 高级安全专家
- `zero-trust` - 零信任安全

## 🚀 快速开始

### macOS / Linux

```bash
# 快速安装 (核心功能)
bash <(curl -sL https://raw.githubusercontent.com/Kafka330/openclaw-install-scripts/main/quick-install.sh)

# 完整安装 (全部功能)
bash <(curl -sL https://raw.githubusercontent.com/Kafka330/openclaw-install-scripts/main/install-openclaw.sh)
```

### Windows

```powershell
# PowerShell (推荐)
irm https://raw.githubusercontent.com/Kafka330/openclaw-install-scripts/main/install-openclaw.ps1 | iex

# CMD (管理员身份运行)
curl -sLO https://raw.githubusercontent.com/Kafka330/openclaw-install-scripts/main/install-openclaw.bat
install-openclaw.bat
```

## 📁 脚本说明

| 脚本 | 平台 | 说明 |
|------|------|------|
| `install-openclaw.sh` | macOS/Linux | 完整安装脚本 |
| `quick-install.sh` | macOS/Linux | 快速安装脚本 |
| `install-openclaw.ps1` | Windows | PowerShell 完整版 |
| `install-openclaw.bat` | Windows | CMD 兼容版 |

## 📂 安装后目录结构

```
~/.openclaw/workspace/
├── skills/       # Skills 目录
├── scripts/      # 快捷脚本
└── memory/      # 数据存储
```

## 🛠️ 常用命令

```bash
# 查看 OpenClaw 状态
openclaw status

# 安装新 Skill
npx clawhub@latest install <skill-name>

# 查看已安装 Skills
openclaw skills list

# 运行浏览器自动化
agent-browser open https://example.com
```

## 📊 内置监控

脚本会自动配置以下监控任务：

- **AI 热门项目每日报告** - 每天 08:00 自动更新
- **GitHub Trending 监控** - 每小时检查

## 🔗 相关链接

- [OpenClaw 官网](https://openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [ClawHub](https://clawhub.com)
- [OpenClaw 文档](https://docs.openclaw.ai)

## 📝 License

MIT License - Feel free to use and modify!

## 🤝 贡献

欢迎提交 PR 或 Issue！
