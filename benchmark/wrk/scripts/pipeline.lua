-- example script demonstrating HTTP pipelining

init = function(args)
	local r = {}
	r[1] = wrk.format(nil, "/?foo")
	r[2] = wrk.format(nil, "/?bar")
	r[3] = wrk.format(nil, "/?baz")

	req = table.concat(r)
end

request = function()
	return req
end

-- 按照順序呼叫 /?foo --> /?bar --> /?baz 這三隻 api
--[[
➜  scripts git:(master) ✗ wrk -s pipeline.lua -d 1 http://127.0.0.1
Running 1s test @ http://127.0.0.1
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     6.05ms    3.03ms  37.88ms   76.79%
    Req/Sec     2.08k   280.60     2.63k    77.27%
  4554 requests in 1.10s, 3.69MB read
Requests/sec:   4138.94
Transfer/sec:      3.35MB
]]

-- nginx log
--[[
172.17.0.1 - - [21/Jun/2020:14:30:13 +0000] "GET /?baz HTTP/1.1" 200 612 "-" "-" "-"
172.17.0.1 - - [21/Jun/2020:14:30:13 +0000] "GET /?foo HTTP/1.1" 200 612 "-" "-" "-"
172.17.0.1 - - [21/Jun/2020:14:30:13 +0000] "GET /?foo HTTP/1.1" 200 612 "-" "-" "-"
172.17.0.1 - - [21/Jun/2020:14:30:13 +0000] "GET /?foo HTTP/1.1" 200 612 "-" "-" "-"
172.17.0.1 - - [21/Jun/2020:14:30:13 +0000] "GET /?foo HTTP/1.1" 200 612 "-" "-" "-"
172.17.0.1 - - [21/Jun/2020:14:30:13 +0000] "GET /?bar HTTP/1.1" 200 612 "-" "-" "-"
]]
