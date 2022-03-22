# intro
提供壓力測試，確認es效能

# installation
- ab
> yum -y install httpd-tools

- wrk
```bash
#!/bin/bash

# centos
sudo yum groupinstall -y 'Development Tools'
sudo yum install -y openssl-devel git 
git clone https://github.com/wg/wrk.git wrk
cd wrk
make
# move the executable to somewhere in your PATH
sudo cp wrk /usr/bin/
```

# ab
> ab -p post.json -T application/json -c 1000 -n 10000 http://127.0.0.1:9200/hello/employee

# wrk
> wrk -s body.lua -c100 -t8 -d5 http://127.0.0.1:9200/hello/employee


# refer:

### install ab
- https://blog.csdn.net/zhang197093/article/details/78395877

### install wrk
- https://github.com/wg/wrk/wiki/Installing-Wrk-on-Linux


### 使用ss監控

- https://www.itread01.com/content/1546443498.html
1. `ss -s`: 監控socket summary
2. `ulimit -n`: 確認最大可開啟檔案數，以及最大可執行的執行緒個數
3. `cat /proc/sys/fs/file-max`: 檢查linux系統最多允許同時開啟檔案數
	> 修改方法`cat 99999 > /proc/sys/fs/file-max`
4. 調整網路核心對`TCP連線`的最大連線數: `vi /etc/sysctl.conf`
	1. 設定本地埠範圍: net.ipv3.ip_local_port_range = 1024 65000 (限制port 1024~6500)
	2. 設定系統對`TCP連線`的最大數限制:: `net.netfilter.nf_conntrack_max = 10240`
	3. 重讀設定生效`sysctl -p`
	# refer:
	```md
		> replace `net.ipv4.ip_conntrack_max` with `net.netfilter.nf_conntrack_max`
			- https://serverfault.com/a/846082
		> extend refer ... linux kernel 
			- https://kknews.cc/zh-tw/code/3a6rbea.html
		> socket tuning 
			- http://www.tweaked.io/guide/kernel/?spm=a2c6h.12873639.0.0.3ca6584cGvqATE
	```