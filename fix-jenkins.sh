#!/bin/bash
echo "Fixing Jenkins access..."

# Stop Jenkins
sudo systemctl stop jenkins 2>/dev/null

# Check if it's Docker Jenkins
if docker ps | grep -q jenkins; then
    echo "Jenkins is running in Docker"
    echo "Getting Docker Jenkins info..."
    docker ps | grep jenkins
    echo "To access Docker Jenkins, use:"
    echo "  Password: sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
    exit 0
fi

# For system Jenkins
if [ -f "/etc/default/jenkins" ]; then
    echo "Updating Jenkins configuration..."
    # Change port to 8080 (standard)
    sudo sed -i 's/HTTP_PORT=.*/HTTP_PORT=8080/' /etc/default/jenkins
    sudo sed -i 's/--httpPort=[0-9]*/--httpPort=8080/' /etc/default/jenkins
    
    # Ensure it binds to all interfaces
    sudo sed -i 's/--httpListenAddress=.*//' /etc/default/jenkins
    echo 'JENKINS_ARGS="--webroot=/var/cache/jenkins/war --httpPort=8080"' | sudo tee -a /etc/default/jenkins
fi

# Start Jenkins
sudo systemctl start jenkins
sleep 5

# Get password
echo "Jenkins password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || \
echo "If password not found, check: sudo journalctl -u jenkins | grep -i password"

echo ""
echo "Jenkins should now be accessible at:"
echo "  http://localhost:8080"
echo "  or"
echo "  http://$(hostname -I | awk '{print $1}'):8080"
