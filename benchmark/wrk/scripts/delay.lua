-- example script that demonstrates adding a random
-- 10-50ms delay before each request

function delay()
	return math.random(10, 50)
end

-- 製作一個隨機延遲的情境
--[[
➜  scripts git:(master) ✗ wrk -s delay.lua -d 1 http://127.0.0.1
Running 1s test @ http://127.0.0.1
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     2.00ms  788.99us   6.24ms   79.37%
    Req/Sec   149.86     16.69   181.00     61.90%
  315 requests in 1.10s, 261.47KB read
Requests/sec:    285.25
Transfer/sec:    236.78KB
]]
