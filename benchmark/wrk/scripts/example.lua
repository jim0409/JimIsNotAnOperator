-- https://blog.huoding.com/2019/08/19/763

math.randomseed(os.time())

local config = {
   {num = 20, path = "/a"},
   {num = 30, method = "get", path = "/b"},
   {num = 50, method = "post", path = "/c", body = "foo=x&bar=y"}
}

local requests = {}

for i, request in ipairs(config) do
   if request.method then
      request.method = string.upper(request.method)
   end

   for _ = 1, request.num do
      requests[#requests + 1] = i
   end
end

local length = #requests

for _ = 1, length do
   local m, n = math.random(length), math.random(length)
   requests[m], requests[n] = requests[n], requests[m]
end

local count = 0

function request()
   local i = (count % length) + 1
   local request = config[requests[i]]
   count = count + 1

   return wrk.format(request.method, request.path, request.headers, request.body)
end
