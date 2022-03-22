-- example script that demonstrates use of thread:stop()

local counter = 1

function response()
	if counter == 100 then
		wrk.thread:stop()
	end
	counter = counter + 1
end

-- 通過counter來計算總請求個數
-- 以下例子為 2 thread, 每一個 thread 打 100 個請求
--[[
➜  scripts git:(master) ✗ wrk -s stop.lua -d 1 http://127.0.0.1
Running 1s test @ http://127.0.0.1
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     4.42ms    1.24ms   7.33ms   67.00%
    Req/Sec     0.00      0.00     0.00       nan%
  200 requests in 1.00s, 166.02KB read
Requests/sec:    199.80
Transfer/sec:    165.85KB
]]
