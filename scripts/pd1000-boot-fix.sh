#!/bin/bash
# Pudidun PD1000 UPS 开机修复脚本

echo "[$(date)] Starting PD1000 UPS fix..." >> /var/log/pd1000-fix.log

# 检查并修复配置
if ! grep -q "subdriver=krauler" /etc/nut/ups.conf 2>/dev/null; then
  echo "Fixing ups.conf..." >> /var/log/pd1000-fix.log
fi

systemctl restart nut-driver@1100231 nut-server nut-monitor 2>/dev/null || true

echo "Fix completed." >> /var/log/pd1000-fix.log
