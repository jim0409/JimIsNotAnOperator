# mongo 做持久化
1. 在deployment文件中加入`volumes`，提供給containers做使用


```yml
spec:
  # replicas: 3 # number of pods need to create
  selector:
    matchLabels:
      app: mongo
  template:
    metadata:
      labels:
        app: mongo
    spec:
      hostNetwork: false 
      containers:
        ...

        volumeMounts:
         - name: mongo-persistent-storage
           mountPath: /data/db

      volumes:
        - name: mongo-persistent-storage
          persistentVolumeClaim:
            claimName: mongo-volumeclaim
```

2. 新增一個`pvc.yml`，給deployment.yml參照
```yml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: mongo-volumeclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
```

# refer:
- https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/master/wordpress-persistent-disks