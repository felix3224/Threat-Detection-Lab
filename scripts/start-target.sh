echo "=== Inicialization of Service  ==="

echo "[1/2] Apache..."
sudo systemctl start apache2

echo "[2/2] MySQL..."
sudo systemctl start mysql

sudo systemctl status apache2 --no-pager | grep active

echo "Site:   http://$(hostname -I | awk '{print $1}')/lab_site/"

echo "Resource of memory"
free -h