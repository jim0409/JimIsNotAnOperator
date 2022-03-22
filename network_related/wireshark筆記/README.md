# intro wireshark
分析封包用的工具。

# flow
分析流程；網卡 -> IP 層 -> TCP/UDP層 -> 應用層(HTTP/DNS層)

# 關於 畸形包(malformed-packet)
因為分析是從 下層(網卡) 到 上層(協議)，
因此在分析下層協議的時候，並不會知道報文有錯。

他會一直分析，直到錯誤的一層。

但每一層並不是獨立的，是有關聯的；

例如，IP層協議裡面有一個字段為報文的總長度
(ip.length + udp.length + dns.length；或著為 packet.length - ether.length)

如果packet.length - ether.length 大於 ip.length。Wireshark在ip層是不會報錯的，因為`IP層的協議並沒有錯誤定義`

既然`ip.tot_length`面決定了上層協議的長度，那麼如果上層協議的內容長度大於`ip.tot_length`呢?只要上層結構內容正確，就算是一個正常的報文。但是因為`ip.tot_length`長度錯了，導致上層協議在解析時出現了結構錯誤，那麼就會出現`Malformed Packet`的情況了。

### content-from-refer
- ip.tot_length = udp.length + dns.length + ip.length
- udp.length = ip.tot_length - ip.length
- dns.length = udp.length - sizeof(udp_header), sizeof(udp_header)

1. ip.tot_length: ip報文的總長度
2. udp.length: udp頭部長度
3. packet.length: 報文總長度
4. dns.length: dns請求報文長度
5. ether.length: 乙太網長度


# refer:
- http://www.iprotocolsec.com/2012/04/02/wireshark-malformed-packet/

# extend-dns hacking
- https://www.chainnews.com/articles/809952159760.htm