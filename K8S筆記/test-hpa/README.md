# intro
1. deploy hello-world service
> kubectl create -f deployment.yml

2. install resource metrics (這邊使用記憶體監控)
> kubectl create -f metrics.yml

2. check hpa
> kubectl get hpa
<!-- 詳細用 kubectl describe hpa -->


# refer:
- https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/horitzontal-pod-autoscaler/testing-hpa/