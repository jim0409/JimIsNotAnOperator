local http = require "socket.http"
local cjson = require "cjson"
local ltn12 = require "ltn12"

local _M = {}

function _M.rest_req(url, body, decoder, bear_token)
	local data = ""
	local req_method = "GET"
	local req_headers = {}
	local req_source

	local function collect(chunk)
		if chunk ~= nil then
			data = data .. chunk
		end
		return true
	end

	if body ~= nil then
		local req_body = cjson.encode(body)
		req_method = "POST"
		req_headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = #req_body,
			["Authorization"] = bear_token
		}

		req_source = ltn12.source.string(req_body)
	else
		req_headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = bear_token
		}
	end

	local ok, code, headers, resp_headers =
		http.request {
		url = url,
		method = req_method,
		headers = req_headers,
		source = req_source,
		sink = collect
	}

	local r = cjson.decode(data)
	if r == nil then
		return "failed"
	end

	return decoder(r)
end

return _M
