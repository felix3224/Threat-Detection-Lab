#!/bin/bash
echo "=== Inicialization Tools of Monitoramento  ==="

echo "[1/4] Elasticsearch..."
sudo systemctl start elasticsearch
sleep 10

echo "[2/4] Kibana..."
sudo systemctl start kibana
sleep 5

echo "[3/4] Filebeat..."
sudo systemctl start filebeat

echo "[4/4] Zeek (IDS)..."
sudo zeekctl deploy
sleep 3

echo "Result"

sudo systemctl status elasticsearch --no-pager | grep active
sudo systemctl status kibana --no-pager | grep active
sudo systemctl status filebeat --no-pager | grep active
sudo zeekctl status 

echo "=== Acessos ==="
echo "Kibana: http://$(hostname -I | awk '{print $1}'):5601"

echo "Resource of memory"
free -h
