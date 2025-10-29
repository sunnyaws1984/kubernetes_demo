# MongoDB StatefulSet Demo (No Persistent Storage)

This is a **single-file demo** to deploy MongoDB as a **Kubernetes StatefulSet** with **no persistent storage**.  
You can copy-paste the commands directly into your terminal to deploy and connect to MongoDB.

---

##  Deploy MongoDB

```bash
- Apply the headless service and StatefulSet:

#kubectl apply -f headless-service.yaml
#kubectl apply -f mongodb-statefulset.yaml

- Check that the pods are running:

#kubectl get pods -l app=mongodb

- Connect Externally (Optional)

#kubectl port-forward pod/mongodb-0 27017:27017

- Access Mongo Shell Inside the Pod

#kubectl exec -it mongodb-0 -- bash
#mongosh
#show dbs

- Scale the StatefulSet

kubectl scale statefulset mongodb --replicas=5
kubectl get pods -l app=mongodb

All pods are Reachable via below URL:

mongodb-0.mongodb.default.svc.cluster.local
mongodb-1.mongodb.default.svc.cluster.local

- Delete the StatefulSet and headless service when done:

kubectl delete -f mongodb-statefulset.yaml
kubectl delete -f headless-service.yaml