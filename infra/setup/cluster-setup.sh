kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# first add our custom repo to your local helm repositories
helm repo add headlamp https://headlamp-k8s.github.io/headlamp/

# now you should be able to install headlamp via helm
helm install my-headlamp headlamp/headlamp --namespace kube-system


# Metrics Server
# kubectl apply -k setup/metrics-server/kustomization.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml
kubectl patch -n kube-system deployment metrics-server --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'


# Headlamp
export POD_NAME=$(kubectl get pods --namespace kube-system -l "app.kubernetes.io/name=headlamp,app.kubernetes.io/instance=my-headlamp" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace kube-system $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace kube-system port-forward $POD_NAME 8080:$CONTAINER_PORT
kubectl create token my-headlamp --namespace kube-system
# TOKEN eyJhbGciOiJSUzI1NiIsImtpZCI6Ijd6VjI4cXhJZzhaM2ZZUU1ya1hPem11ckZ1M1dRUGFLam9DNnB5ZnoweDQifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNjk2MjA3ODY2LCJpYXQiOjE2OTYyMDQyNjYsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJteS1oZWFkbGFtcCIsInVpZCI6IjlkZDgwYmI2LTMwZjktNDk3OC05Zjg1LTUzMDBkN2M5ZTkzNSJ9fSwibmJmIjoxNjk2MjA0MjY2LCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06bXktaGVhZGxhbXAifQ.aMRb2KQJKaEB20N4azvnSOhCwyOIuBLA_Kk1Au-DktoPRBQy1HGnspGk0Agb7O3W6YTSS2FdHY_5m_ZVyvkEHpK4S7qW8josZR6m_S5QXYh4RlZ_Uz84D968qKGG5Jb9RUt8CDiqm_ORz7ZKM_bj6w0j_ciyEAYHl8Lkau1HNoxzIMgb1aIH8j52WBBaov7IcJD-7eJLzRDfpVJMGwHT2ktgzhDiJbpoxdkklzNU_0h6vyFKYldMcKiDSgyy1L60_TQp1KViT4i18WzO6r7h_ErUbdYYzeJqwD6e56bpTfVJPeCKFrHMSdTb671d5muF47VxkLSLE6uQzIVNcaIUqg