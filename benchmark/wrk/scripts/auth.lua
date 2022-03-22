-- example script that demonstrates response handling and
-- retrieving an authentication token to set on all future
-- requests

token = nil
path = "/authenticate"

request = function()
	return wrk.format("GET", path)
end

response = function(status, headers, body)
	if not token and status == 200 then
		token = headers["X-Token"]
		path = "/resource"
		wrk.headers["X-Token"] = token
	end
end

-- 計算登入...
--[[
➜  scripts git:(master) ✗ wrk -s auth.lua -d 1 http://127.0.0.1/
Running 1s test @ http://127.0.0.1/
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.43ms    1.81ms  21.51ms   87.89%
    Req/Sec     1.50k   215.84     1.84k    47.62%
  3139 requests in 1.10s, 0.97MB read
  Non-2xx or 3xx responses: 3139
Requests/sec:   2853.63
Transfer/sec:      0.88MB
]]
