# intro
因為wrk在luajit中使用的lua-vm並無共享記憶體功能

所以針對部分的需要預先請求，並且使用共用記憶體的壓力測試情境

使用script來做驅動

# dep
1. jq
```
sudo yum install -y epel-release
sudo yum install -y jq
```

# refer:
- https://blog.csdn.net/qq_38423105/article/details/89786736
- 
