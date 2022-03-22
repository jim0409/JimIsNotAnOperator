# intro
iptables是運行在使用者空間的應用軟體，通過控制Linux核心netfilter模組，來管理網路封包的處理和轉發。

iptables、ip6tables等都使用Xtables框架。存在「表（tables）」、「鏈（chain）」和「規則（rules）」三個層面。

# filter表
filter表是預設的表，如果不指明表則使用此表。其通常用於過濾封包。其中的內建鏈包括：
```
INPUT，輸入鏈。發往本機的封包通過此鏈。
OUTPUT，輸出鏈。從本機發出的封包通過此鏈。
FORWARD，轉發鏈。本機轉發的封包通過此鏈。
```

# nat表
nat表如其名，用於位址轉換操作。其中的內建鏈包括：
```
PREROUTING，路由前鏈，在處理路由規則前通過此鏈，通常用於目的位址轉換（DNAT）。
POSTROUTING，路由後鏈，完成路由規則後通過此鏈，通常用於源位址轉換（SNAT）。
OUTPUT，輸出鏈，類似PREROUTING，但是處理本機發出的封包。
```

# mangle表
mangle表用於處理封包。其和nat表的主要區別在於，nat表側重連接而mangle表側重每一個封包。內建鏈列表如下。
```
PREROUTING
OUTPUT
FORWARD
INPUT
POSTROUTING
```

# raw表
raw表用於處理異常，有如下兩個內建鏈：
```
PREROUTING
OUTPUT
```

# refer:
- https://zh.wikipedia.org/wiki/Iptables