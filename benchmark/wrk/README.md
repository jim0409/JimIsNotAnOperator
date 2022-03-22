# intro
wrk 為一個github.com 開源有 25k+ 的 benchmark tool

相較於ab，雖然附屬參數不多。但是可以透過`lua`支持使用更多變化的`benchmark method`

# 使用 wrk -s 來指定 script 從而達到壓力測試
```lua
local wrk = {
   scheme  = "http",
   host    = "localhost",
   port    = nil,
   method  = "GET",
   path    = "/",
   headers = {},
   body    = nil,
   thread  = nil,
}
```

# wrk 內建函數
- setup
線程啟動前調用
```lua
```

- init
每次請求發送之前被調用，可以接受 wrk 命令行的額外參數。
```lua
```

- delay
這個函數返回一個數值，在這次請求執行完以後延遲多久時間才執行下一個請求，可以對應 thinking time 的場景。
```lua
```

- request
通過這個函數可以每次請求之前修改本次請求 body 和 請求 header，同時也可以撰寫一些壓力測試的邏輯。
```lua
```

- response
每次請求返回以後被調用，可以根據response做處理，譬如遇到錯誤的response則停止執行測試，或將錯誤內容打印到stdout
```lua
```



# setup test env
> docker run --rm --name target_nginx -p 80:80 -d nginx:1.13.7


# stop test env
> docker stop target_nginx


# refer:
- https://blog.huoding.com/2019/08/19/763 
- https://mgleon08.github.io/blog/2018/04/09/http-benchmark/
- http://xiaorui.cc/archives/5098


# wrk 開源提供測試腳本
- https://github.com/wg/wrk/tree/master/scripts


# 探討 wrk 的併發數量
- https://github.com/wg/wrk/issues/205#issuecomment-241214051


# installation
- https://github.com/wg/wrk/wiki/Installing-wrk-on-Linux


# advanced sceniaro setup
- http://czerasz.com/2015/07/19/wrk-http-benchmarking-tool-example/


# jwt-package
- https://github.com/Olivine-Labs/lua-jwt