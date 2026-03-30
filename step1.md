## Explore the cluster

The cluster is ready with demo workloads deployed in the `demo` namespace.

Try these commands:

```
kubectl get pods -n demo
kubectl get deployments -n demo
kubectl get services -n demo
kubectl describe deployment nginx-web -n demo
kubectl logs -l app=nginx-web -n demo
kubectl get configmap app-config -o yaml -n demo
kubectl top pods -n demo
```
