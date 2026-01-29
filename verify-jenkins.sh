#!/bin/bash
echo "==========================================="
echo "✅ JENKINS VERIFICATION"
echo "==========================================="

# Check if Jenkins is running
if curl -s -I http://localhost:9191 >/dev/null; then
    echo "Status: Jenkins is running on port 9191"
    echo "Access URL: http://localhost:9191"
    
    # Check if we can get password
    if [ -f "/var/lib/jenkins/secrets/initialAdminPassword" ]; then
        echo "Password file: Found"
        echo "To get password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    else
        echo "Password file: Not found in default location"
    fi
    
    # Get Jenkins version
    echo "Jenkins headers:"
    curl -s -I http://localhost:9191 | grep -i "server\|x-jenkins"
    
else
    echo "Status: Jenkins not responding on port 9191"
fi

echo "==========================================="
