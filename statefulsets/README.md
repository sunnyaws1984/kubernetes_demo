# MongoDB StatefulSet Demo (No Persistent Storage)

This is a **single-file demo** to deploy MongoDB as a **Kubernetes StatefulSet** with **no persistent storage**.  
You can copy-paste the commands directly into your terminal to deploy and connect to MongoDB.

---

##  Deploy MongoDB

```bash
- Apply the headless service and StatefulSet:

kubectl apply -f headless-service.yaml
kubectl apply -f mongodb-statefulset.yaml

- Check that the pods are running:

kubectl get pods -l app=mongodb

- So how do these 3 MongoDB replicas sync?

    MongoDB syncs internally only when:
    You initialize the replica set manually or via script 
    MongoDB chooses one Primary
    The other two become Secondary
    Secondaries automatically sync (replicate) all writes from the Primary

- Connect Externally (Optional)

kubectl exec -it mongodb-0 -- mongosh "mongodb://mongodb-0.mongodb:27017"
** Run below command to execute now initialize the replica set

rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongodb-0.mongodb:27017" },
    { _id: 1, host: "mongodb-1.mongodb:27017" },
    { _id: 2, host: "mongodb-2.mongodb:27017" }
  ]
})

You should get:
{ ok: 1 }

rs.status()
You should see:
 PRIMARY = mongodb-0
 SECONDARY = mongodb-1
 SECONDARY = mongodb-2

show dbs - list default DBs

All pods are Reachable via below URL:
    mongodb-0.mongodb.default.svc.cluster.local
    mongodb-1.mongodb.default.svc.cluster.local
    mongodb-2.mongodb.default.svc.cluster.local

- Delete the StatefulSet and headless service when done:

kubectl delete -f mongodb-statefulset.yaml
kubectl delete -f headless-service.yaml