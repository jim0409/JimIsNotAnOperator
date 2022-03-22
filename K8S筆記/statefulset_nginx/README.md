# intro
StatefulSet 是用來管理有狀態應用的 load balance API object

StatefulSet 用來管理 Deployment 和擴展 Pod，並且㡪為這些生成的 Pod 創建一個固定的 Pod-ID

# 限制

1. 給定 Pod 的存儲，通常會先預先宣告一個 PV，並且基於該 PVC 來生成 Pod
2. 刪除 StatefulSet 的 Pod 不會連帶刪除 他對應的 PVC，也確保資料可以保存下來
3. StatefulSet 需要 headless service 來負責 Pod 的網路識別



# refer:
- https://kubernetes.io/zh/docs/concepts/workloads/controllers/statefulset/