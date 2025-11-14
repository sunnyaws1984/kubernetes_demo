# MongoDB StatefulSet Demo (No Persistent Storage)

Advantages of StatefulSets in Kubernetes:
*Stable, Unique Network Identities
*Each pod gets a stable hostname (e.g., mongodb-0, mongodb-1).
*Other pods/services can reliably connect to it using this hostname.
*Pods are created in order: pod-0 → pod-1 → pod-2
*Pods are terminated or updated in reverse order.
*Helps applications that rely on startup/shutdown sequences
*Each pod keeps its name and volume even after rescheduling
*Critical for applications that need stable identities to replicate data.

StatefulSets are perfect for databases (MongoDB, MySQL, Cassandra), queues (Kafka, RabbitMQ), and any clustered apps that require:

Stable identity
Persistent storage
Ordered deployment & update
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

## Access DB
 kubectl exec -it mongodb-0 -- mongosh "mongodb://mongodb-0.mongodb:27017"
use myDatabase
db.myCollection.insertOne({ name: "Mark", age: 30 })
show collections
db.myCollection.find()
show dbs

- Delete the StatefulSet and headless service when done:

kubectl delete -f mongodb-statefulset.yaml
kubectl delete -f headless-service.yaml