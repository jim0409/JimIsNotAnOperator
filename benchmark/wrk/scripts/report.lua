-- example reporting script which demonstrates a custom
-- done() function that prints latency percentiles as CSV

done = function(summary, latency, requests)
	io.write("------------------------------\n")
	for _, p in pairs({50, 90, 99, 99.999}) do
		n = latency:percentile(p)
		io.write(string.format("%g%%,%d\n", p, n))
	end
end

--[[
➜  scripts git:(master) ✗ wrk -s report.lua -d 1 http://127.0.0.1
Running 1s test @ http://127.0.0.1
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.47ms    1.63ms  14.50ms   77.25%
    Req/Sec     1.46k   345.07     2.00k    54.55%
  3206 requests in 1.10s, 2.60MB read
Requests/sec:   2914.03
Transfer/sec:      2.36MB
------------------------------
50%,3044
90%,5597
99%,8993
99.999%,14498
]]
