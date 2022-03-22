# intro
### 安全性問題與對策
### 一般對策
大部分的安全性問題可以透過數位簽章或是MAC(Message Authentication Code)來防護。

要求`Authorization Server`必須實作TLS，版本則隨時間推移而不同。


### 偽造或竄改AccessToken的問題
attacker可能透過既有的`AccessToken`進行竄改，以圖拿到對應的資料
> 將每次核發token的內容部分抽取成id，並且加上該id對應的規則。將該id緩存在伺服器，讓attacker更難去竄改內容，即便竄改也難以猜到對應id的行為


### AccessToken傳輸過程中外洩或暴露敏感資料
中間人攻擊、監聽 可能導致AccessToken資料內容外洩
> 除了使用TLS來實作傳輸過程，`Client <-> AuthServer`需要對Token實作一些規則性的加密。並且避免把Token放在`Cookie`進行傳輸。(因為Cookie會以req Header公開被傳輸)


### 挪用Access Token的問題
attacker可能會透過A member拿到Access Token後，再用該Access Token拿到對應的資料。倘若該Access Token賦予給B，可以讓B拿到對應的資料。
> 在Token驗證規則裡，額外增加一條。確認`申請Token人`的資訊。倘若`申請人`與申請動作人員不一致則拒絕操作。此外也要限制`Access Token`能做的事情的scope

### 多次利用Access Token
attacker可以透過`緩存`，重複利用該Access Token以圖達到某些利益
> 應該把有效時間這因素考慮進Token的設計內


# small conclusion
1. 要藏好Token: Token需要加密，且加密規則要嚴格把關
2. 要用TLS的驗證: ssl需要同時實作於`client<->AuthServer`及`client<->ResourceServer`
3. 不要把BearToken存在`Cookie`
4. 要限制發送Token的過期時間
5. 要核發有使用範圍的`Bearer Token`(限定scope)
6. 不要用Page URL來傳送`Bearer Token`(querystring跟Cookie有相同風險)


# refer:
- https://blog.yorkxin.org/2013/09/30/oauth2-6-bearer-token.html

