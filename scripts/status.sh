#!/bin/bash
echo "=== SOC LAB STATUS ==="
sudo systemctl status elasticsearch --no-pager | grep active
sudo systemctl status kibana --no-pager | grep active
sudo systemctl status filebeat --no-pager | grep active
sudo zeekctl status | head 1
echo "Memória: $(free -h | grep Mem)"

echo "Use of memory"
free -h