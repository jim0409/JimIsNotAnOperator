local rest_req = require "request".rest_req
local uri = "http://127.0.0.1/test"

local function decoder(dic)
	return dic["message"]
end

-- test case 1 [GET] method
print(rest_req(uri, nil, decoder))

-- test case 2 [POST] method
local body = {
	["message"] = "msg_ok"
}

print(rest_req(uri, body, decoder))
