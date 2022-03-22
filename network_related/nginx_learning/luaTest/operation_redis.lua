-- lua-resty-redis

local redis = require "resty.redis"

REDIS_HOST = "127.0.0.1"
REDIS_PORT = 6379

redis_client = redis:new()

local ok, err = redis_client:connect(REDIS_HOST, REDIS_PORT)