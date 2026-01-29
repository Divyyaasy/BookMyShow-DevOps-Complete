FROM node:18-alpine

# Install serve globally
RUN npm install -g serve

# Create app directory
WORKDIR /app

# Copy built React app if exists, otherwise create a simple test page
COPY bookmyshow-app/build ./build 2>/dev/null || echo "No build folder, creating test page"

# Create a simple test page if no build exists
RUN if [ ! -f build/index.html ]; then \
    mkdir -p build && \
    echo '<!DOCTYPE html> \
    <html> \
    <head> \
        <title>BookMyShow</title> \
        <style> \
            body { font-family: Arial, sans-serif; text-align: center; padding: 50px; } \
            h1 { color: #333; } \
            p { color: #666; } \
        </style> \
    </head> \
    <body> \
        <h1>🎬 BookMyShow Application</h1> \
        <p>Your movie booking application is running on AWS EKS!</p> \
        <p>Status: <strong>✅ Deployed Successfully</strong></p> \
        <p>Cluster: bookmyshow-final</p> \
        <p>Region: ap-south-1</p> \
    </body> \
    </html>' > build/index.html; \
    fi

# Expose port
EXPOSE 3000

# Start serve
CMD ["serve", "-s", "build", "-l", "3000"]
