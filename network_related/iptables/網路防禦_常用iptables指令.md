# iptables 常用指令
### 限制tcp練線數
- 限制每個IP連接 HTTP(80 port) 最大病發數為50個
> iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 50 -j REJECT

- 限制每個IP的TCP連線數最多100個
> iptables -I INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 100 -j REJECT

- 限制每個IP同時5個80 port轉發，超過的丟棄
> iptables -I FORWARD -p tcp --syn --dport 80 -m connlimit --connlimit-above 5 -j DROP

- 限制每個IP在60秒內允許新建立30個連接數
> iptables -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --update --seconds 60 --hitcount 30 -j REJECT

- 每秒最多允許5個新連接封包數
> iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 5 -j ACCEPT

- 防止各種端口掃描
> iptables -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST SYN -m limit --limit 1/s -j ACCEPT

### 防止syn flood(check with `vim /var/log/kern.log`)
- 創建一個叫做`SYNFLOOD`的規則鏈
> iptables -N SYNFLOOD

```md
1. 限制syn包的速度，每秒1個，超過則丟棄
> iptables -A SYNFLOOD -p tcp --syn -m limit --limit 1/s -j RETURN

2. 紀錄這些在`SYNFLOOD`表格內的數據，俵予以`警告`的等級
> iptables -A SYNFLOOD -p tcp -j LOG --log-level alert

3. 將`tcp-reset`包做丟棄
> iptables -A SYNFLOOD -p tcp -j REJECT --reject-with tcp-reset

4. 將iptables裡面的INPUT加上一個新的規則叫做`SYNFLOOD`
> iptables -A INPUT -p tcp -m state --state NEW -j SYNFLOOD



root@ubuntu:/home/ubuntu# iptables -L -nv
Chain INPUT (policy ACCEPT 25 packets, 1468 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 SYNFLOOD   tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            state NEW

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 17 packets, 1412 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain SYNFLOOD (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp flags:0x17/0x02 limit: avg 1/sec burst 5
    0     0 LOG        tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            LOG flags 0 level 1
    0     0 REJECT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            reject-with tcp-reset
```


### 防止ping flood攻擊

- 創建一個叫做`PING`的規則鏈
> iptables -N PING
ping
```md
1. 限制icmp的echo-request，每秒最多回應一個`echo-requet`(限制每個IP的`ping`的速度)
> iptables -A PING -p icmp --icmp-type echo-request -m limit --limit 1/s -j RETURN

2.  把PING記錄起來並且存成`alert`的告警
> iptables -A PING -p icmp -j LOG --log-level alert

3. 將多餘的ping丟棄
> iptables -A PING -p icmp -j REJECT

4. 
> iptables -A INPUT -p icmp --icmp-type echo-request -m state --state NEW -j PING


root@ubuntu:/home/ubuntu# iptables -L -nv
Chain INPUT (policy ACCEPT 47 packets, 3432 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 PING       icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 8 state NEW

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 29 packets, 3540 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain PING (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 RETURN     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 8 limit: avg 1/sec burst 5
    0     0 LOG        icmp --  *      *       0.0.0.0/0            0.0.0.0/0            LOG flags 0 level 1
    0     0 REJECT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            reject-with icmp-port-unreachable


### check with 
1. 攻擊是否記錄下來 `tail -f /var/log/kern.log`
2. 誰ping我 `sudo tcpdump -i ethX icmp and icmp[icmptype]=icmp-echo`
3. Test Command `mz -c 10 -A rand -B 10.0.2.4 -T icmp "ping" -v`
```

### 清除所有的iptables規則
> iptables -F


# refer:

常用的iptables指令
- https://dotblogs.com.tw/ghoseliang/2012/10/05/75289

鳥哥~
- http://linux.vbird.org/linux_server/0250simple_firewall.php

找iptables的log
- https://askubuntu.com/questions/348439/where-can-i-find-the-iptables-log-file-and-how-can-i-change-its-location

用tcpdump檢查誰ping我
- https://askubuntu.com/questions/430069/how-to-monitor-who-is-pinging-me


```iptables的說明
root@ubuntu:/home/ubuntu# iptables -h
iptables v1.6.1

Usage: iptables -[ACD] chain rule-specification [options]
       iptables -I chain [rulenum] rule-specification [options]
       iptables -R chain rulenum rule-specification [options]
       iptables -D chain rulenum [options]
       iptables -[LS] [chain [rulenum]] [options]
       iptables -[FZ] [chain] [options]
       iptables -[NX] chain
       iptables -E old-chain-name new-chain-name
       iptables -P chain target [options]
       iptables -h (print this help information)

Commands:
Either long or short options are allowed.
  --append  -A chain		Append to chain
  --check   -C chain		Check for the existence of a rule
  --delete  -D chain		Delete matching rule from chain
  --delete  -D chain rulenum
				Delete rule rulenum (1 = first) from chain
  --insert  -I chain [rulenum]
				Insert in chain as rulenum (default 1=first)
  --replace -R chain rulenum
				Replace rule rulenum (1 = first) in chain
  --list    -L [chain [rulenum]]
				List the rules in a chain or all chains
  --list-rules -S [chain [rulenum]]
				Print the rules in a chain or all chains
  --flush   -F [chain]		Delete all rules in  chain or all chains
  --zero    -Z [chain [rulenum]]
				Zero counters in chain or all chains
  --new     -N chain		Create a new user-defined chain
  --delete-chain
            -X [chain]		Delete a user-defined chain
  --policy  -P chain target
				Change policy on chain to target
  --rename-chain
            -E old-chain new-chain
				Change chain name, (moving any references)
Options:
    --ipv4	-4		Nothing (line is ignored by ip6tables-restore)
    --ipv6	-6		Error (line is ignored by iptables-restore)
[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'
[!] --source	-s address[/mask][...]
				source specification
[!] --destination -d address[/mask][...]
				destination specification
[!] --in-interface -i input name[+]
				network interface name ([+] for wildcard)
 --jump	-j target
				target for rule (may load target extension)
  --goto      -g chain
                              jump to chain with no return
  --match	-m match
				extended match (may load extension)
  --numeric	-n		numeric output of addresses and ports
[!] --out-interface -o output name[+]
				network interface name ([+] for wildcard)
  --table	-t table	table to manipulate (default: `filter')
  --verbose	-v		verbose mode
  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up
  --wait-interval -W [usecs]	wait time to try to acquire xtables lock
				default is 1 second
  --line-numbers		print line numbers when listing
  --exact	-x		expand numbers (display exact values)
[!] --fragment	-f		match second or further fragments only
  --modprobe=<command>		try to insert modules using this command
  --set-counters PKTS BYTES	set the counter during insert/append
[!] --version	-V		print package version.
```