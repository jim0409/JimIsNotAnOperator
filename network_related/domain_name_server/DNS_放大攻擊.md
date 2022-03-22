# 前言
DNS系統基本是一種採樹狀階層式(hierarchy)的結構，類似 Windows 中的目錄樹結構，

最頂層的有數十個 root DNS servers，記錄著所有最頂層 DNS server 資料，稱為「root」或根目錄，


# DNS放大攻擊
攻擊者 偽造dns查詢的請求包，發送大量地請求數據包到DNS伺服器上，

### DNS 放大攻擊流程

1. 攻擊者向已受控制的殭屍電腦群下達開始攻擊指令。
2. 遭感染的殭屍電腦群向未做好安全設定的 DNS server發出偽造的DNS query 封包，偽造成受害者的 IP 位置成來源位置來進行遞迴查詢。
3. 受害的 DNS 主機向根目錄 Server 進行 domain 查詢。
4. 根目錄主機向受害 DNS 主機回傳查詢無此 domain 的訊息，並回傳另一根伺服器可能有其 domain 資料。
5. 受害 DNS 主機轉向另一根目錄 Server 進行 domain 查詢。
6. 外部根目錄 Server 回傳知道此 domain 資料的 DNS server 位置。
7. 受害 DNS 主機再度向此 DNS 發出查詢。
8. 外部 DNS 回傳受害 DNS 主機 domain 查詢資料。
9. 受害 DNS 主機向遭偽造來源的主機回傳 domain 查詢資料。

攻擊者透過不斷重複上述步驟，向目標主機發送大量 UDP 封包，藉此阻斷其正常服務，也由於受害 DNS 主機回傳到目標主機之封包大小會大於殭屍電腦群所發送的封包大小， 攻擊過程中流量具有放大的效果，故稱其為 DNS 放大攻擊。


### Simulation
1. victim
> attack cmd
2. hacker
> query dns with
3. dns_server




# refer:
Dns amplification
- http://www.cc.ntu.edu.tw/chinese/epaper/0028/20140320_2808.html
SNMP attack
- https://kknews.cc/zh-tw/code/jm8oeal.html
dns-packets analyze
- https://resources.infosecinstitute.com/dns-analysis-and-tools/#gref


# extend-refer
- https://www.ithome.com.tw/tech/87819


# different between reflection & amplification attack
- https://security.stackexchange.com/questions/93820/dns-reflection-attack-vs-dns-amplification-attack