local goodsSurplus
local flag
-- 判斷用戶是否已搶過
local buyMembersKey = tostring(KEYS[1])
local memberUid = tonumber(ARGV[1])
local goodsSurplusKey = tostring(KEYS[2])
local hasBuy = redis.call("sIsMember", buyMembersKey, memberUid)

-- 已經搶過，返回0
if hasBuy ~= 0 then
	return 0
end

-- 準備搶購
goodsSurplus = redis.call("GET", goodsSurplusKey)
if goodsSurplus == false then
	return 0
end

-- 沒有剩餘可搶購物品
goodsSurplus = tonumber(goodsSurplus)
if goodsSurplus <= 0 then
	return 0
end

flag = redis.call("SADD", buyMembersKey, memberUid)
flag = redis.call("DECR", goodsSurplusKey)

return 1

-- pre-require: copy this buy.lua to /tmp/buy.lua

-- init data: 這邊腳本參數透過`,`來做`鍵`與`值`的區隔，兩組分別寫入`KEYS`和`ARGV`
-- (Note: when using --eval the comma separates KEYS[] from ARGV[] items)
--[[
REDISCLI_AUTH=yourpassword redis-cli --eval /tmp/buy.lua hadBuyUids goodsSurplus , 10
REDISCLI_AUTH=yourpassword redis-cli set goodsSurplus 5
]]

-- purchase: 透過賦予 hadBuyUids 鍵對應值，同時扣除商品 goodsSurplus 的值來達到交易
--[[
REDISCLI_AUTH=yourpassword redis-cli --eval /tmp/buy.lua hadBuyUids goodsSurplus , 1
REDISCLI_AUTH=yourpassword redis-cli --eval /tmp/buy.lua hadBuyUids goodsSurplus , 2
REDISCLI_AUTH=yourpassword redis-cli --eval /tmp/buy.lua hadBuyUids goodsSurplus , 3
REDISCLI_AUTH=yourpassword redis-cli --eval /tmp/buy.lua hadBuyUids goodsSurplus , 4
REDISCLI_AUTH=yourpassword redis-cli --eval /tmp/buy.lua hadBuyUids goodsSurplus , 5
]]
