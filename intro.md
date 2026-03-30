# Kubernetes Interactive Lab

Welcome to a **real** Kubernetes cluster.

The environment is being set up with live workloads — give it a few seconds.

Once ready you'll have:

| Resource | Details |
|----------|---------|
| `nginx-web` | Deployment, 2 replicas |
| `redis-cache` | Deployment, 1 replica |
| `nginx-service` | ClusterIP service |
| `redis-service` | ClusterIP service |
| `app-config` | ConfigMap with app settings |

## Try these commands

```bash
kubectl get pods
kubectl get all
kubectl describe deployment nginx-web
kubectl logs -l app=nginx-web
kubectl get configmap app-config -o yaml
kubectl top pods
```

Explore freely — this is a real cluster.
