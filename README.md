# fnOS 不支持品牌 UPS 通用修复方案

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![fnOS](https://img.shields.io/badge/fnOS-Compatible-blue)
![NUT](https://img.shields.io/badge/NUT-UPS%20Driver-green)

一个由 AI 辅助完成的**飞牛私有云 fnOS** UPS 兼容方案，专注于解决官方**不支持品牌**的 UPS 设备问题（显示 0000、驱动失败等）。

## 项目背景

飞牛 fnOS 系统在连接第三方/廉价 UPS 时，经常遇到官方不支持的情况：

- UPS 页面显示设备 ID 为 `0000` 或未知，无法选择和保存
- NUT 驱动报 `Device not supported!`
- `nut-scanner` 能检测到 USB 设备，但缺少正确的 `subdriver`、`langid_fix` 等配置

本仓库提供**通用修复方案**，通过 AI 辅助诊断 NUT 配置，让大多数**能被系统识别**的 UPS 正常工作（显示品牌、型号、电量、剩余时间，支持界面设置关机延迟等）。

**重要说明**：
作者目前仅持有 fnOS 环境，未测试群晖 DSM、威联通 QNAP 等其他 NAS。但原理高度相似（均基于 NUT UPS 驱动）。只要 `lsusb` / `nut-scanner` 能识别 USB 设备，问题多半是驱动配置导致，通常可解决。其他 NAS 用户可自行参考或提交 PR 补充经验。

## 核心功能

- **NUT 配置自动修复**（krauler 等子驱动 + langid_fix）
- **开机自启动修复脚本**
- **飞牛保存配置后自动修复**（Path 监听）
- **电池参数优化**（续航估算等）
- **保留原生 UPS 事件回调**

## 使用方法

### 方式一：直接复制 AI Prompt（推荐）

```text
我的 fnOS 上 [你的UPS品牌型号] 被识别成 [vendor:product]，需要按 nutdrv_qx + [合适子驱动] 修复。

请按以下流程操作：
1. SSH 登录后运行 lsusb、nut-scanner -U、upsc [设备名]@localhost 等诊断命令。
2. 修复 /etc/nut/ups.conf，添加正确的 subdriver、langid_fix、显示名称、电池参数。
3. 保持 /etc/nut/upssched.conf 使用飞牛原生回调。
4. 重启相关 NUT 服务。
5. 创建开机修复脚本和 systemd path 监听（监控 ups.conf 变化）。
6. 根据需要设置关机延迟（如断电 3 分钟 = 180 秒）。
7. 测试配置自动修复功能。
```

补充你的具体 UPS 信息、SSH 细节、期望关机时间后发给 AI 即可。

### 方式二：手动操作
详见 `docs/详细修复流程.md`。

## 文件结构

```
fnOS-Unsupported-UPS-Fix/
├── README.md
├── docs/
│   └── 详细修复流程.md
├── scripts/
│   ├── fix-ups-conf.py
│   ├── boot-fix.sh
│   └── fix-ups-conf.service
└── LICENSE
```

## 贡献
欢迎 PR 其他 UPS 型号、其他 NAS（群晖、QNAP 等）的适配经验，一起完善！

## 致谢
- 飞牛官方论坛
- AI 大模型（Grok 等）的强大诊断能力
- 所有尝试廉价 UPS 的 fnOS 用户
