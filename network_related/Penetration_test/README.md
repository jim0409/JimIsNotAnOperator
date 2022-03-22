# intro

XSS 漏洞攻擊起始於網頁應用程式與使用者所輸入的一些動態生成原件有關。

透過一些內嵌的javascript指令可以拿到使用者相關資訊。甚至是網頁瀏覽資訊。

# Cross-Site Scripting(XSS)
Cross-site scripting (XSS) 是一種常見的網頁應用程式資安漏洞

XSS促使攻擊者可以在client-side可以在網頁的某個頁面下注入一些攻擊

典型的攻擊有
1. Reflected XSS
2. Stored XSS
3. Dom Based XSS

# example
以下利用網站`demo.testfire.net`做範例
> http://demo.testfire.net/feedback.jsp


# Reflected XSS
當使用者點擊一個經過設計的連結就有可能被執行特定的Script

在form裡面的`name`填入`jim`可以發現，他會回饋
```log
Thank You
Thank you for your comments, jim. They will be reviewed by our Customer Service staff and given the full attention that they deserve. However, the email you gave is incorrect () and you will not receive a response.
```
由此處可以發現`jim`是一個相對的回饋元素


如果將`name` 的地方改注入以下script，
```js
<script>alert(document.cookie);</script>
```

會看到彈跳視窗
```
demo.testfire.net says ...
```

表示他會讀取有`document`元件相關的`cookie`

又或者~
> http://demo.testfire.net/search.jsp?query=<script>alert("hello")</script>

# Stored XSS
Stored XSS透過Javscript將部分資訊存入網站資料庫中，最常見的例子就是網頁留言板或是訊息。
由於留言格式不拘，可以在留言內注入一些腳本，等待下一個瀏覽該留言板的受害者。


# DOM-Based XSS
DOM-XXS的攻擊防護需要坐在client-side，Reflected與Stored XXS可以透過server-side的防護與驗證。

- DOM攻擊有
	1. document.url
	2. document.cookie
	3. window.location.search
	4. history.replaceState


# notes:
常見XSS攻擊手法
> https://portswigger.net/web-security/cross-site-scripting/cheat-sheet



# refer:
- https://www.qa-knowhow.com/?p=2992

- https://en.wikipedia.org/wiki/Penetration_test

- https://www.youtube.com/watch?v=nXxj6JgFxzw

- https://www.youtube.com/watch?v=7M-R6U2i5iI