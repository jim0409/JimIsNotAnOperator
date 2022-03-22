local _M

--[[
	宣告一個數字，從數字中亂數生成對應的request組別
	數字通常跟thread number有關
]]
function _M.random_request(num)
	math.randomseed(os.time())

	local config = {
		{num = 1, method = "GET", path = "/test"},
		{num = 1, method = "GET", path = "/test"},
		{num = 1, method = "POST", path = "/test", body = {["message"] = "msg~~ok"}}
	}

	local permutations = {}

	for i, request in ipairs(config) do
		if request.method then
			request.method = string.upper(request.method)
		end

		for _ = 1, request.num do
			permutations[#permutations + 1] = i
		end
	end

	local length = #permutations

	for _ = 1, length do
		local m, n = math.random(length), math.random(length)
		permutations[m], permutations[n] = permutations[n], permutations[m]
	end

	local count = 0

	local function request()
		local i = (count % length) + 1
		local request = config[permutations[i]]
		count = count + 1

		-- return wrk.format(request.method, request.path, request.headers, request.body)
		print(request.method, request.path, request.headers, request.body)
	end

	for i = 1, 10, 1 do
		request()
	end
end

return _M
