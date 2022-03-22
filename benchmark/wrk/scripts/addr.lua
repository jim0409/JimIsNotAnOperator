-- example script that demonstrates use of setup() to pass
-- a random server address to each thread

local addrs = nil

function setup(thread)
	if not addrs then
		addrs = wrk.lookup(wrk.host, wrk.port or "http")
		-- refer : http://www.lua.org/manual/5.1/manual.html#2.5.5
		-- 		 : https://stackoverflow.com/a/17974661
		-- `#` 表示長度: 通常用來規避 table 中有 nil 值的情境
		for i = #addrs, 1, -1 do
			if not wrk.connect(addrs[i]) then
				table.remove(addrs, i)
			end
		end
	end

	thread.addr = addrs[math.random(#addrs)]
end

function init(args)
	local msg = "thread addr: %s"
	print(msg:format(wrk.thread.addr))
end

--[[
➜  scripts git:(master) ✗ wrk -s addr.lua -t8 -d 1 http://127.0.0.1
thread addr: 127.0.0.1:80
thread addr: 127.0.0.1:80
thread addr: 127.0.0.1:80
thread addr: 127.0.0.1:80
thread addr: 127.0.0.1:80
thread addr: 127.0.0.1:80
thread addr: 127.0.0.1:80
thread addr: 127.0.0.1:80
Running 1s test @ http://127.0.0.1
  8 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     2.57ms  844.50us  10.14ms   75.48%
    Req/Sec   388.74     41.86   474.00     73.86%
  3407 requests in 1.10s, 2.76MB read
Requests/sec:   3095.01
Transfer/sec:      2.51MB
]]
