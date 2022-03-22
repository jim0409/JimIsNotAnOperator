# 為什麼做 deployment-cluster ?
少數狀況會有服務轉移的需求

前期通常沒有什麼流量，可以使用 container 進行服務，伴隨後期業務增長

可能會需要將 k8s 內部的服務搬遷到 vm，但倘若為 容器 混合 VM 架構

一般的 statefulset 影響的範圍可能是全部集群，所以才會獨立進行部署

另外，針對像是 mq / db 這類型的服務，非必要通常也不會加上 HPA(horizontal pod autoscaler)

相對 statefulset 就沒有那麼大的優勢了 ...
