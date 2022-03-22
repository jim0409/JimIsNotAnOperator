# intro
使用 nginx 實現最小化直播功能
1. rtmp -> push
2. http-flv -> pull

# quick start
1. docker-compose up -d

2. 使用 OBS 進行螢幕錄製 (rtmp push ... key 123)

3. 打開 http://127.0.0.1，在 http-flv 輸入以下網址
<!-- > http://localhost:8002/liveflv?port=1935&app=live&stream={CHANNEL_ID} -->
> http://localhost:8002/liveflv?port=1935&app=live&stream=123

# refer:
- https://github.com/mailbyms/docker-http-flv
- http://bilibili.github.io/flv.js/demo/