#!/bin/bash
echo "=== Parando SOC Lab ==="

sudo systemctl stop apache2 mysql
sudo zeekctl stop
sudo systemctl stop filebeat kibana elasticsearch

echo "Serviços parados."
free -h
