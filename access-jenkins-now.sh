#!/bin/bash
echo "==========================================="
echo "🚀 ACCESS JENKINS NOW"
echo "==========================================="

echo "Jenkins URL: http://localhost:9191"
echo ""

# Try multiple methods to get password
echo "Method 1: Check common password locations..."
PASSWORD_FILE=""
for file in \
  /var/lib/jenkins/secrets/initialAdminPassword \
  /var/jenkins_home/secrets/initialAdminPassword \
  /jenkins_home/secrets/initialAdminPassword; do
    if [ -f "$file" ]; then
        PASSWORD_FILE="$file"
        break
    fi
done

if [ -n "$PASSWORD_FILE" ]; then
    echo "✅ Found password file: $PASSWORD_FILE"
    echo "Password:"
    sudo cat "$PASSWORD_FILE"
else
    echo "❌ No password file found in common locations"
fi

echo ""
echo "Method 2: Check Docker..."
if sudo docker ps | grep -q jenkins; then
    echo "✅ Jenkins is running in Docker"
    echo "Getting password from Docker container..."
    sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || \
    echo "Could not get password from Docker"
fi

echo ""
echo "Method 3: Reset Jenkins security (if you can't find password)..."
read -p "Do you want to reset Jenkins security? (y/n): " choice
if [[ $choice == "y" ]]; then
    echo "Stopping Jenkins..."
    sudo kill $(sudo netstat -tlnp | grep :9191 | awk '{print $7}' | cut -d'/' -f1) 2>/dev/null
    
    echo "Finding Jenkins home..."
    # Try to find Jenkins config
    CONFIG_FILE=$(sudo find / -name "config.xml" -path "*jenkins*" 2>/dev/null | head -1)
    if [ -n "$CONFIG_FILE" ]; then
        echo "Found config at: $CONFIG_FILE"
        sudo cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
        sudo sed -i 's/<useSecurity>true<\/useSecurity>/<useSecurity>false<\/useSecurity>/' "$CONFIG_FILE"
        echo "Security disabled. Restart Jenkins to access without password."
    else
        echo "Could not find Jenkins config file."
    fi
fi

echo ""
echo "==========================================="
echo "INSTRUCTIONS:"
echo "1. Open browser: http://localhost:9191"
echo "2. Enter password shown above"
echo "3. If no password, try accessing anyway"
echo "==========================================="
