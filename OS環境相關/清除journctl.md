# 清除 journctl

## 直接刪除
```sh
sudo rm -rf /var/log/journal/*
sudo systemctl restart systemd-journald.service
```


# 只保留固定天數
```sh
sudo journalctl --vacuum-time=30d
```

# refer:
- https://www.peterdavehello.org/2020/01/clean-up-linux-systemd-journal-logs/