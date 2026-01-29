#!/bin/bash
echo "==========================================="
echo "🚀 DEPLOYING BOOKMYSHOW MICROSERVICES"
echo "==========================================="

# Build and push Docker images
services=("user-service" "movie-service" "booking-service" "payment-service" "api-gateway")

for service in "${services[@]}"; do
    echo ""
    echo "📦 Building $service..."
    cd "microservices/$service"
    
    # Create package.json if missing
    if [ ! -f "package.json" ]; then
        echo "   Creating package.json..."
        cat > package.json << PKGEOF
{
  "name": "$service",
  "version": "1.0.0",
  "description": "$service microservice",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
PKGEOF
    fi
    
    # Build Docker image
    docker build -t 371457438480.dkr.ecr.ap-south-1.amazonaws.com/$service:latest .
    
    # Push to ECR
    aws ecr get-login-password --region ap-south-1 | \
      docker login --username AWS --password-stdin 371457438480.dkr.ecr.ap-south-1.amazonaws.com
    docker push 371457438480.dkr.ecr.ap-south-1.amazonaws.com/$service:latest
    
    cd ../..
done

# Deploy to Kubernetes
echo ""
echo "☸️  Deploying to Kubernetes..."
kubectl apply -f k8s-microservices/namespace.yaml
kubectl apply -f k8s-microservices/configmap.yaml
kubectl apply -f k8s-microservices/secrets.yaml

# Deploy microservices
for service in "${services[@]}"; do
    kubectl apply -f "microservices/$service/k8s/deployment.yaml"
done

kubectl apply -f k8s-microservices/services.yaml
kubectl apply -f k8s-microservices/ingress.yaml

# Wait for deployment
echo ""
echo "⏳ Waiting for deployments to be ready..."
for service in "${services[@]}"; do
    kubectl rollout status deployment/$service -n bookmyshow-microservices --timeout=300s
done

# Get service URL
echo ""
echo "✅ Deployment complete!"
echo "🌐 API Gateway URL:"
kubectl get svc api-gateway -n bookmyshow-microservices -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' || echo "Not ready yet"

echo ""
echo "==========================================="
