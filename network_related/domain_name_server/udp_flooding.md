# UDP flooding
UDP flood 又稱UDP洪水攻擊，或UDP淹沒攻擊
> UDP是沒有連接狀態的協議，因此可以發送大量的UDP包到某個port。如果是個正常的UDP應用port，則可能干擾正常應用。如果是沒有正常應用，伺服器要回送ICMP，同樣消耗伺服器的處理資源，而且很容易阻塞上行鏈路的帶寬。


# 補充 
使用mz發送udp封包
### refer:
- http://man7.org/linux/man-pages/man8/mausezahn.8.html

mz (Mausezahn)
```
       To use the ''raw-layer-2'' scheme, simply specify the desired frame
       as a hexadecimal sequence (the ''hex-string''), such as:

         mausezahn eth0 "00:ab:cd:ef:00 00:00:00:00:00:01 08:00 ca:fe:ba:be"

       In this example, whitespaces within the byte string are optional and
       separate the Ethernet fields (destination and source address, type
       field, and a short payload). The only additional options supported
       are ''-a'', ''-b'', ''-c'', and ''-p''. The frame length must be
       greater than or equal to 15 bytes.

       The ''higher-layer'' scheme is enabled using the ''-t <packet-type>''
       option.  This option activates a packet builder, and besides the
       ''packet-type'', an optional ''arg-string'' can be specified. The
       ''arg-string'' contains packet- specific parameters, such as TCP
       flags, port numbers, etc. (see example section).
```
1. mz支持一般`指令模式`跟`互動模式`
2. mz最常用的方法是`-t`可以用來指定協議(protocol)
    - 可以透過 `mz -t help` 來查看支援的協議種類
    - 可以透過 `mz -t tcp help` 來查看支持的tcp協議的使用說明
3. 透過`-A`指定要編寫的packet來源IP;也可以換成DomainName(不寫的話，預設是該interface的IP)
4. 透過`-B`指定要送出的packet的目的IP;也可以換成DomainName
e.g. 透過網卡`enp0s3`發送到`10.0.2.15`，其中源port為`100`目標port為`50001`。包內夾帶字串為`Test ASCII context`
> mz enp0s3 -B 10.0.2.15 -t udp "dp=5001, sp=100" -P "Test ASCII context"




# extend refer
UDP flooding
- https://kknews.cc/code/p6en6vj.html