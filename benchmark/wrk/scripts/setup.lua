-- example script that demonstrates use of setup() to pass
-- data to and from the threads

local counter = 1
local threads = {}

function setup(thread)
	thread:set("id", counter)
	table.insert(threads, thread)
	counter = counter + 1
end

function init(args)
	requests = 0
	responses = 0

	local msg = "thread %d created"
	print(msg:format(id))
end

function request()
	requests = requests + 1
	return wrk.request()
end

function response(status, headers, body)
	responses = responses + 1
end

function done(summary, latency, requests)
	for index, thread in ipairs(threads) do
		local id = thread:get("id")
		local requests = thread:get("requests")
		local responses = thread:get("responses")
		local msg = "thread %d made %d requests and got %d responses"
		print(msg:format(id, requests, responses))
	end
end

--[[
➜  scripts git:(master) ✗ wrk -s setup.lua -d 5 http://127.0.0.1
thread 1 created
thread 2 created
Running 5s test @ http://127.0.0.1
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.00ms    1.12ms  18.04ms   77.88%
    Req/Sec     1.65k   272.37     2.17k    74.49%
  16125 requests in 5.01s, 13.07MB read
Requests/sec:   3221.06
Transfer/sec:      2.61MB
thread 1 made 8064 requests and got 8058 responses
thread 2 made 8072 requests and got 8067 responses
]]
