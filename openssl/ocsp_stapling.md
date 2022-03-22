# intro
OCSP(Online Certificate Status Protocol, 在線證書狀態協議)是用來檢驗證書合法性的在線查詢服務，一般由證書所屬`CA`提供

某些客戶端會在TLS握手階段近一步協商時，查詢OCSP接口，並在獲得結果前阻塞後續流程。OCSP查詢本質是一次完整的HTTP request-response

這中間DNS查詢、建立TCP、服務端處理等環節都可能耗費很長時間，導致最終TLS連接時間變得更長

而OCSP Stapline(OCSP封套)，是指服務端`主動獲取OCSP`查詢結果並隨著證書一起發送給客戶端，從而讓客戶端跳自己去驗證的過程，提高TLS握手效率


# 驗證OCSP Stapling狀態
1. 通過前面提到的`SSL Labs`這個強大的在線服務，驗證指定網站是否開啟`OCSP Stapling`
2. 使用`Wireshark`設置好抓包條件和過濾器後，也可以很方便地驗證某個網站是否開啟`OCSP Stapling`
3. 使用的openssl版本不能太舊

服務端啟用`OCSP Stapline之後`，客戶端還需要在建立`TLS`時，在`Client Hello`中啟用`status_request`這個TLS擴展，告訴服務端自己希望得到`OCSP Response`

目前主流瀏覽器都會帶上`status_request`，而在`openssl`中需要指定`-status`參數，晚整命令如下。
> openssl s_client -connect imququ.com:443 -status -tlsextdebug < /dev/null 2>&1 | grep -i "OCSP response"

如果服務器上部署多個`HTTPS`站點，可能需要加上`-servername`參數啟用SNI:
> openssl s_client -connect imququ.com:443 -servername imququ.com -status -tlsextdebug < /dev/null 2>&1 | grep -i "OCSP response"
```測試結果<OCSP Staplig已開啟>
OCSP response:
OCSP Response Data:
    OCSP Response Status: successful (0x0)
    Response Type: Basic OCSP Response
```
```測試結果<OCSP Staplig未開啟>
OCSP response: no response sent
```


# 獲取證書OCSP Response
去掉上面命令中的`grep`指令，可以獲取網站`https://imququ.com`的OCSP Response
> openssl s_client -connect imququ.com:443 -status -tlsextdebug < /dev/null 2>&1
```
OCSP response:
====================================
OCSP Response Data:
	...
Certificate:
	...
```
OCSP Response主要由`OCSP Response Data`及`Certificate`組成。
- OCSP Response Data 是該網站(imququ.com)的證書驗證信息
- Certificate則是用來驗證`OCSP Response Data`
該網站中的`Certificate`的`Common Name`是`RapidSSL SHA256 CA - G4 OCSP Responder`，可以看出它屬於`RapidSSL`的OCSP服務
(註：不是每一家CA的OCSP Response都會提供`Certificate`信息)

以上這段OCSP response信息主要是通過服務端`OCSP Stapline`獲取的


# 在本地，透過openssl獲取OCSP Stapline
> openssl s_client -connect imququ.com:443 -showcerts < /dev/null 2>&1


# refer:
- https://imququ.com/post/why-can-not-turn-on-ocsp-stapling.html