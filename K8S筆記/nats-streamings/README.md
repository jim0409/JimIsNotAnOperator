# 動機
透過官網範例，練習部署 nats & nats-streaming

# 使用 gke 進行測試
1. 創建 namespace
> kubectl create namespace nats

2. 部署 nats
> kubectl apply -f nats

3. 部署 nats-streaming
> kubectl apply -f nats-streaming


# refer:
- https://docs.nats.io/nats-on-kubernetes/minimal-setup
