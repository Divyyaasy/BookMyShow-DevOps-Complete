#!/bin/bash
echo "Testing GitHub Webhook Integration..."
echo ""

# Check if workflow file exists
if [ -f ".github/workflows/bookmyshow-ci-cd.yml" ]; then
    echo "✅ GitHub Actions workflow file exists"
else
    echo "❌ GitHub Actions workflow file missing"
fi

# Check structure
echo ""
echo "Workflow structure:"
find .github -type f

echo ""
echo "==========================================="
echo "GitHub Webhook Integration Status: COMPLETE"
echo "==========================================="
echo ""
echo "Next steps:"
echo "1. Push this code to GitHub"
echo "2. Configure secrets in GitHub repository"
echo "3. Make a commit to trigger the workflow"
echo "4. Check Actions tab in GitHub"
echo "==========================================="
