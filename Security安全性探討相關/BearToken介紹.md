# BearToken
用途:
除了涵括`OAuth2.0(RFC 6749)`定義Client如何取得`AccessToken`的方法；(Client <-> Resource Server)

額外定義了Authorization Server，來強制要求 (Client <-> AuthServer) <->  Resource Server

# 格式
`Bearer ${b64token}`

```
b64token = 1*( ALPHA / DIGIT / "-" / "." / "_" / "~" / "+" / "/" ) *"="
(正規表達: [A-Za-z0-9\-\._~\+\/]+=*/)
```

# 流程
1. Client 向 Resource Server 發出 Access Token
- curl with HTTP Header
```log (normal GET)
GET /resource HTTP/1.1
Host: server.example.com
Authorization: Bearer mF_9.B5f-4.1JqM
```

or

- curl with POST body
```log (form data)
POST /resource HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded

access_token=mF_9.B5f-4.1JqM
```

or

- curl with querying string (not recommand)
```log (query string)
GET /resource?access_token=mF_9.B5f-4.1JqM HTTP/1.1
Host: server.example.com
```


2. Client透過`AuthServer`提供的AccessToken來訪問`Resource Server`



# refer:
- https://blog.yorkxin.org/2013/09/30/oauth2-6-bearer-token.html



# notes:
### Resource Server 向 Client 提示 `認證失敗，拒絕存取`
1. 沒有提供`Access Token`
2. 不㪋法Token，例如過期、Resource Owner沒有Client不允許該Client拿取資料

以上錯誤將由header `WWW-Authenticate`，使用auth-scheme `Bearer`來提供

- Resource Server Response (example)
```log
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer realm="example",
                  error="invalid_token",
                  error_description="The access token expired"
```

- invalid_request(400 Bad Request):
	1. 沒提供必要的參數
	2. 提供不支援的參數
	3. 提供了錯誤的參數值
	4. 同樣的參數出現多次
	5. 使用一種以上的方法來出示`Access Token`(如放在header裡卻錯放在form裡)
	6. 無法解讀request的情況

- invalid_token(401 Unauthorized):
	1. Access Token過期
	2. 被收回授權
	3. 無法解讀
	4. 其他Access Token不合法的情況
	> 這種情況下，Client可以重新申請一個Access Token並用新的Access Token來重試Request

- insufficient_scope(403 Forbidden)
	1. 這個request需要出示比當前Client出示的Access Token代表的scopes還要更多的scopes
	> 可以另外提供`scope` auth-param 來具體指出需要哪些`scopes`


### Authorization Server 給 Client 核發 Access Token
循`OAuth 2.0`的spec來核發，範例spec如下

```log 
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
Cache-Control: no-store
Pragma: no-cache

{
  "access_token":"mF_9.B5f-4.1JqM",
  "token_type":"Bearer",
  "expires_in":3600,
  "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA"
}
```

