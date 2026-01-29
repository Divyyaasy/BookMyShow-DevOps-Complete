# GitHub Secrets Configuration

## Required Secrets for CI/CD:

1. **AWS_ACCESS_KEY_ID** - AWS Access Key
2. **AWS_SECRET_ACCESS_KEY** - AWS Secret Key

## How to set up:

1. Go to your GitHub repository
2. Click on "Settings" → "Secrets and variables" → "Actions"
3. Click "New repository secret"
4. Add the following secrets:


## Webhook Configuration:

1. Repository Settings → Webhooks → Add webhook
2. Payload URL: https://api.github.com/repos/{owner}/{repo}/dispatches
3. Content type: application/json
4. Events: Push, Pull Request
5. Secret: [generate secret]

## Jenkins Webhook Alternative:

If using Jenkins, configure:
- Jenkins URL: http://<jenkins-ip>:9191/github-webhook/
- GitHub plugin installed
- Credentials configured
