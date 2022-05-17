# 動機
為求開發快速，創建openresty base image
1. 環境切割乾淨
2. 相依物件少
3. 下載快速
4. 迭代及啟動快速

# 相關教學文章
1. 使用[resty-cli](https://blog.openresty.com.cn/cn/resty-cmd/)做簡單測試及除錯處理
2. 使用[resty-]


# 目前已經引用模組
- ngx_stream_ipdb_module
> https://github.com/vislee/ngx_stream_ipdb_module

- ngx_http_ipdb_module
> https://github.com/vislee/ngx_http_ipdb_module


# refer:
- https://github.com/gojek/lua-dev/blob/master/Dockerfile
- https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile
# extend-refer:
> 參考官方rpmbuild的SPEC文檔
- https://github.com/williamcaban/ngx_openresty-rpm-spec/blob/master/SPECS/ngx_openresty.spec
