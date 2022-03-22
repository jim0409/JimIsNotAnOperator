# intro
假設 mac 的硬碟容量不是很大，但是手邊有一台備用的 centos7 伺服器

利用 centos7 的備用硬碟，掛載給 mac 來加以利用!!


### 安裝 centos7 下執行 NFS 必要套件
> sudo yum install -y nfs-utils rpcbind

### 編輯 centos7 檔案暴露 NFS 位置
vi /etc/exports
```新增加一行
/home/nfs-source ${CLIENT_IP}(rw,subtree_check,insecure,nohide)
```

### 啟動
service nfs start

### 連接
Go > Connect To Server ... > 在連接欄位輸入 nfs://${IP}/home/nfs-source


# refer:
- https://github.com/jaywcjlove/handbook/blob/master/CentOS/Mac%E4%BD%BF%E7%94%A8NFS%E8%BF%9E%E6%8E%A5CentOS%E4%B8%8A%E7%9A%84%E5%85%B1%E4%BA%AB%E6%96%87%E4%BB%B6%E5%A4%B9.md
