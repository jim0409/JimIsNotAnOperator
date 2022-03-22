-- example dynamic request script which demonstrates changing
-- the request path and a header for each request
-------------------------------------------------------------
-- NOTE: each wrk thread has an independent Lua scripting
-- context and thus there will be one counter per thread

counter = 0

request = function()
	path = "/" .. counter
	wrk.headers["X-Counter"] = counter
	counter = counter + 1
	return wrk.format(nil, path)
end

-- 計算是否有該回傳 Header "X-Counter"
--[[
➜  scripts git:(master) ✗ wrk -s counter.lua -d 1 http://127.0.0.1/
Running 1s test @ http://127.0.0.1/
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.01ms    1.46ms  30.56ms   88.95%
    Req/Sec     1.69k   156.55     1.94k    54.55%
  3691 requests in 1.10s, 1.14MB read
  Non-2xx or 3xx responses: 3691
Requests/sec:   3355.96
Transfer/sec:      1.04MB
]]
