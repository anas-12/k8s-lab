#!/bin/bash

# Wait for the cluster to be fully ready
while ! kubectl get nodes | grep -q "Ready"; do
  sleep 2
done

# Create demo namespace
kubectl create namespace demo

# Deploy demo resources
cat <<EOF | kubectl apply -f - -n demo
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  environment: "demo"
  app_version: "2.0.0"
  log_level: "info"
  max_connections: "100"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-web
  labels:
    app: nginx-web
    tier: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-web
  template:
    metadata:
      labels:
        app: nginx-web
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "32Mi"
            cpu: "25m"
          limits:
            memory: "64Mi"
            cpu: "100m"
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx-web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-cache
  labels:
    app: redis-cache
    tier: cache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-cache
  template:
    metadata:
      labels:
        app: redis-cache
        tier: cache
    spec:
      containers:
      - name: redis
        image: redis:alpine
        ports:
        - containerPort: 6379
        resources:
          requests:
            memory: "16Mi"
            cpu: "10m"
          limits:
            memory: "32Mi"
            cpu: "50m"
---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
spec:
  selector:
    app: redis-cache
  ports:
  - protocol: TCP
    port: 6379
    targetPort: 6379
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: lab-quota
spec:
  hard:
    pods: "10"
    requests.cpu: "500m"
    requests.memory: "256Mi"
EOF

# Set demo namespace as default for the session
kubectl config set-context --current --namespace=demo
