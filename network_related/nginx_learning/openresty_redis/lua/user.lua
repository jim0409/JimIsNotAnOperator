function connect_redis()
    local client, errmsg = redis:new()
    if not client then
        ngx.log(ngx.ERR, "get redis failed: " .. (errmsg or "nil"))
        return;
    end

    client:set_timeout(10000)  --10秒

    -- 要換成 redis container的內部ip
    local result, errmsg = client:connect('172.20.0.3', 6379) --redis server host and port
    if not result then
        ngx.log(ngx.ERR, "connect redis failed: " .. (errmsg or "nil"))
        return
    end

    return client
end

function close_redis(rediscli)
    if rediscli then
        rediscli:set_keepalive(0, 10000) --connection poll timeout and pool size
    end
end

ngx.req.read_body()
args=ngx.req.get_uri_args()
if (ngx.var.uri == '/getredis') then
    local redcli=connect_redis()
    if not redcli then
        ngx.say('connect redis error.')
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    ngx.say(redcli:hget('user', args.name))
    close_redis(redcli)
elseif (ngx.var.uri == '/setredis') then
    local redcli=connect_redis()
    if not redcli then
        ngx.say('connect redis error.')
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    ngx.say(redcli:hset('user', args.name, args.email))
    close_redis(redcli)
end