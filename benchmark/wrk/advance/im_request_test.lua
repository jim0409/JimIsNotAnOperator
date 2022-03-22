local rest_req = require "request".rest_req
local base_url = "http://morse-test.dev-pds.svc.cluster.local:8000"
local cjson = require "cjson"

local function get_access_token()
	local login_url = base_url .. "/v1/login"
	local login_body = {
		["country"] = "TW",
		["phone"] = "886975000000",
		["password"] = "password",
		["device_id"] = "100000",
		["grant_type"] = "password"
	}

	local function retrive_token(dic)
		return dic["result"]["access_token"]
	end

	return rest_req(login_url, login_body, retrive_token)
end

local bear_token = get_access_token()

function setup(thread)
	-- if bear_token == nil then
	-- 	print("count1")
	-- 	bear_token = get_access_token()
	-- end
	bear_token = bear_token
	print(bear_token)
end

request = function()
	body = {
		["type"] = "text",
		["group_id"] = "gmc2sdpq86n88l0nqfti6g",
		["text"] = "some test text"
	}
	msg_body = cjson.encode(body)
	headers = {
		["Content-Type"] = "application/json",
		["Content-Length"] = #msg_body,
		["Authorization"] = "Bearer " .. bear_token
	}
	return wrk.format("POST", "/v1/messages", headers, msg_body)
end

-- request = function()
-- 	local body = {
-- 		["type"] = "text",
-- 		["group_id"] = "gmc2sdpq86n88l0nqfti6g",
-- 		["text"] = "some test text"
-- 	}
-- 	local msg_body = cjson.encode(body)
-- 	local headers = {
-- 		["Content-Type"] = "application/json",
-- 		["Content-Length"] = #msg_body,
-- 		["Authorization"] = "Bearer " .. bear_token
-- 	}
-- 	return wrk.format("POST", "/v1/messages", headers, msg_body)
-- end

response = function(status, headers, body)
	print(body)
end

-- wrk.method = "POST"
-- wrk.body = '{"type": "text","group_id": "gmc2sdpq86n88l0nqfti6g","text": "somethingthatmustchangeD"}'
-- wrk.headers["Content-Type"] = "application/json"
-- wrk.headers["Authorization"] = "Bearer " .. bear_token

-- 因為lua會開啟一個VM .. 無法做共用緩存
-- 所以如果 token 是變動的 .. 有可能每次拿到都會異動 ..
-- 整體導致後面的請求皆失敗 ..
