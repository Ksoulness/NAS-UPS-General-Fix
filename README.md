# fnOS Pudidun PD1000 UPS 自动识别与修复方案

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![fnOS](https://img.shields.io/badge/fnOS-Compatible-blue)
![NUT](https://img.shields.io/badge/NUT-UPS%20Driver-green)

一个由 AI（Codex/Grok/Claude 等）辅助完成的**飞牛私有云 fnOS** 廉价 UPS 兼容方案，让官方不支持的 **Pudidun PD1000**（以及同类 0001:0000 设备）完美运行。

## 项目背景

家里电力不稳定，购买了性价比高的 Pudidun PD1000 UPS（带 USB 通讯口）。接入 fnOS 后发现：

- 飞牛 UPS 页面显示设备为 `0000`，无法选择和保存
- NUT 驱动无法正常连接（`Device not supported!`）
- 官方 nut-scanner 能扫描到，但缺少正确的 `subdriver` 和 `langid_fix`

传统方案（探针模式）不够优雅，于是**让 AI 直接分析系统、诊断、生成配置和修复脚本**，最终实现了：

- 飞牛界面正常显示品牌、型号、电量、剩余时间
- 支持在界面修改关机延迟
- 系统更新或保存 UPS 规则后**自动修复**配置（防止被覆盖）
- 开机自愈

本项目把整个过程提炼成**可复用的 AI Prompt + 完整修复流程**，方便其他小白用户直接复制给 AI 助手使用。

## 核心功能

- **NUT 配置自动修复**（krauler 子驱动 + langid_fix）
- **开机自启动修复脚本**
- **飞牛保存配置后 Path 监听自动修复**
- **电池参数优化**（续航估算、电压范围）
- **完全保留飞牛原生 UPS 事件回调**

## 使用方法

### 方式一：直接复制下面 Prompt 给 AI（推荐）

```text
我的 fnOS 上 Pudidun PD1000 UPS 被识别成 0001:0000，需要按 nutdrv_qx + krauler 修复。

请按以下流程做：
1. SSH 连接后先运行 lsusb、nut-scanner -U、upsc 1100231@localhost。
2. 如果 /etc/nut/ups.conf 被飞牛覆盖，请补回 subdriver=krauler、langid_fix=0x0409、Pudidun PD1000 显示字段、电池电压估算和 runtime。
3. 恢复 /etc/nut/upssched.conf 为飞牛原生 /usr/trim/bin/upssched_cmd.sh 回调，不要写自定义关机策略。
4. 重启 nut-driver@1100231、nut-server、nut-monitor。
5. 写入开机修复脚本 /usr/local/sbin/pd1000-boot-fix.sh。
6. 写入 PathChanged=/etc/nut/ups.conf 和 PathChanged=/etc/nut/device.conf 的 systemd path 监听，飞牛保存 UPS 规则后自动修复。
7. 如果要改成断电后 3 分钟关机，把 /etc/nut/device.conf 里的 power-policy.value 设置为 180。
8. 最后模拟删除 subdriver/langid_fix，验证 20 秒内能自动修复，并确认 upsc 返回 OL。
```

把你的 SSH 信息、希望的关机时间等补充进去发给 AI 即可。

### 方式二：手动按帖子步骤操作

详见仓库中的 `docs/详细修复流程.md`。

## 文件结构

```
fnOS-Pudidun-PD1000-UPS-Fix/
├── README.md
├── docs/
│   └── 详细修复流程.md
├── scripts/
│   ├── pd1000-fix-ups-conf.py
│   ├── pd1000-boot-fix.sh
│   └── pd1000-fix-ups-conf.service
└── LICENSE
```

## 贡献

欢迎提交其他 UPS 型号的修复经验，一起完善廉价 UPS 在 fnOS 上的生态！

## 致谢

- 飞牛官方论坛
- AI 大模型的强大分析能力
