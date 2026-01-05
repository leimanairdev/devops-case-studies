cat > k8s-cicd-github-actions/README.md << 'EOF'
# CI/CD to Kubernetes (GitHub Actions)

This project demonstrates a CI/CD pipeline design for a containerized application deployed to Kubernetes. The focus is on pipeline structure, security controls, and deployment strategy rather than a single cloud-provider implementation.

## What’s Included
- Simple Flask app (`app/`) with unit test coverage
- Dockerfile for containerization
- Kubernetes manifests (`k8s/`)
- GitHub Actions workflow (`.github/workflows/cicd.yaml`)

## Pipeline Stages (Recommended)
1. **Build**: build container image
2. **Test**: run unit tests
3. **Security Scan**: scan dependencies and image (e.g., Trivy/Snyk)
4. **Deploy to Staging**: automatic deploy after passing checks
5. **Promote to Production**: approval gate + controlled rollout
6. **Rollback**: revert to last known good release on failure

## Secrets & Credentials Strategy
- Use GitHub Encrypted Secrets or OIDC federation to cloud provider
- Never commit kubeconfigs, tokens, or private keys to source control
- Separate credentials for staging vs production

## Deploy Strategy Notes
- Prefer progressive delivery (rolling updates / canary where possible)
- Add health checks (readiness/liveness) and resource requests/limits
- Use environment-specific overlays (kustomize/helm values)

## How to Run Locally (Dev)
From `app/`:
- Create venv and install deps
- Run tests: `python -m pytest -q`
- Build image: `docker build -t demo-app:local .`

EOF
