# 前置準備
1. heroku 帳號
2. heroku 環境
3. 安裝 vue-cli
4. 創建 static.json
5. 執行 heroku 指令


# 註冊 heroku 帳號
- https://www.heroku.com/

# 設定 heroku 環境
- brew install heroku

# 安裝 vue-cli
- 1. 安裝 nvm
- 2. 安裝 npm
- 3. 安裝 vue-cli, npm install -g @vue/cli

# 創建 static.json
```static.json
{
  "root": "dist",
  "clean_urls": true,
  "routes": {
    "/**": "index.html"
  }
}
```

# 執行 heroku 指令
- 創建 heroku 專案 : `heroku create my-project-test-vue-project`
- 指定 buildpack nodejs : `heroku buildpacks:add heroku/nodejs`
- 指定 buildpack heroku-buildpack-static : `heroku buildpacks:add https://github.com/heroku/heroku-buildpack-static`



# refer:
- https://medium.com/unalai/%E8%AA%8D%E8%AD%98-heroku-%E5%AD%B8%E7%BF%92%E5%B0%87-vue-%E5%B0%88%E6%A1%88%E9%83%A8%E7%BD%B2%E8%87%B3heroku-4f5d8bd9b8e2