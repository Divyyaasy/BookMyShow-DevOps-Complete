#!/bin/bash
echo "==========================================="
echo "🚀 ACCESS JENKINS (Docker on port 8080)"
echo "==========================================="

# Check if Jenkins Docker container is running
if sudo docker ps | grep -q jenkins; then
    echo "✅ Jenkins is running in Docker on port 8080"
    echo ""
    
    # Get Jenkins password
    echo "Getting admin password..."
    PASSWORD=$(sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null)
    
    if [ -n "$PASSWORD" ]; then
        echo "✅ JENKINS PASSWORD FOUND!"
        echo "==========================================="
        echo "🌐 URL: http://localhost:8080"
        echo "🔑 PASSWORD: $PASSWORD"
        echo "==========================================="
        echo ""
        echo "Complete setup:"
        echo "1. Open browser to http://localhost:8080"
        echo "2. Enter the password above"
        echo "3. Install suggested plugins"
        echo "4. Create admin user"
        echo "5. Access Jenkins dashboard"
    else
        echo "❌ Could not get password from Docker container"
        echo "Try checking logs: sudo docker logs jenkins | grep -i password"
    fi
else
    echo "❌ Jenkins Docker container not running"
    echo "Start it with: sudo docker start jenkins"
fi
