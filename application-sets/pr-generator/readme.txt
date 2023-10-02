https://github.com/settings/tokens

export GITHUB_TOKEN=ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

kubectl create secret generic github-token \
  --from-literal=token=$GITHUB_TOKEN \
  -o yaml --dry-run=client > github-token-secret.yaml