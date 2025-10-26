# Kubernetes Project Runbook – WebApp + Redis with HPA

This hands-on project demonstrates key Kubernetes concepts (Pods, Deployments, PV/PVC, ConfigMap, Secrets, Services, and Autoscaling) in one cohesive example.

## Pre-requisites

* A running Kubernetes cluster (Minikube or kind works fine)
* kubectl CLI configured
* Basic knowledge of YAML and Kubernetes resources

## Step-by-Step Deployment Order

### 1️⃣ Create a Namespace

```bash
kubectl apply -f namespace.yml
kubectl get ns
```

### 2️⃣ Create ConfigMap

Configuration data used by the web app.

```bash
kubectl apply -f configmap.yml -n webapp-demo
kubectl get configmap -n webapp-demo
```

### 3️⃣ Create Secrets

Store secure credentials for web app usage.

```bash
echo -n 'admin' > username.txt
echo -n 'p@ssw0rd' > password.txt
kubectl create secret generic app-secret --from-file=./username.txt --from-file=./password.txt -n webapp-demo
kubectl get secrets -n webapp-demo
```

### 4️⃣ Create Persistent Volume & Claim (for Redis)

```bash
kubectl apply -f pv.yml
kubectl apply -f pvc.yml -n webapp-demo
kubectl get pv,pvc -n webapp-demo
```

### 5️⃣ Deploy Redis Backend and verify if it's up and running

```bash
kubectl apply -f redis-deploy.yml -n webapp-demo
kubectl apply -f redis-service.yml -n webapp-demo
kubectl get pods,svc -n webapp-demo

Verify by running below command:
$ kubectl exec -it <POD> -n webapp-demo -- bash (Command to login)
$ kubectl exec -it <REDIS-POD> -n webapp-demo -- redis-cli
127.0.0.1:6379> PING
PONG
127.0.0.1:6379> SET key "hello"
OK
127.0.0.1:6379> GET key
"hello"
127.0.0.1:6379>

```

### 6️⃣ Deploy Web Application and try scaling web app from 1 to 2 or more.

```bash
kubectl apply -f webapp-deploy.yml -n webapp-demo
kubectl apply -f webapp-service.yml -n webapp-demo
kubectl get pods,svc -n webapp-demo
```

### 7️⃣ Configure HPA for Web Application

```bash
kubectl apply -f hpa.yml -n webapp-demo
kubectl get hpa -n webapp-demo
kubectl describe hpa webapp-hpa -n webapp-demo
```

### 8️⃣ Verification

* Check Pods, Services, PVCs, and ConfigMaps:

```bash
kubectl get all -n webapp-demo
kubectl describe pod <pod-name> -n webapp-demo
```

* Test WebApp:

```bash
kubectl exec -it webapp-<POD> -n webapp-demo -- bash
apt update
apt install -y curl (Inside POD) - If needed
http://127.0.0.1:30008/
```

### 9️⃣ Cleanup

```bash
kubectl delete namespace webapp-demo
```

---

This runbook allows you to deploy all resources sequentially and visualize how **Secrets, ConfigMaps, PV/PVCs, Deployments, Services, and HPA** interact in a single project.
