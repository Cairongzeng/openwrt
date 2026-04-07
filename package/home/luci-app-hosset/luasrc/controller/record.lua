-- SPDX-License-Identifier: GPL-3.0-or-later
-- Copyright (C) 2025-2026 Rongzeng Cai <cairongzeng@outlook.com>
module("luci.controller.record", package.seeall)
function index()
-- 	entry({"admin", "settings", "record", "info"}, template("record/info"), _("Info"), 91).dependent = true
	entry({"admin", "internet_record", "get_record_base"}, call("get_record_base"), nil).leaf = true
	entry({"admin", "internet_record", "set_record_base"}, call("set_record_base"), nil).leaf = true
	entry({"admin", "internet_record", "record_action"}, call("record_action"), nil).leaf = true
end
function ensure_record_section(cur)
	local sid
	cur:foreach("hosd", "record", function(s)
		sid = s[".name"]
	end)
	if not sid then
		sid = cur:add("hosd", "record")
	end
	return sid
end
function get_record_base()
	local json = require "luci.jsonc"
	local http = require "luci.http"
	local utl  = require "luci.util"
	local req_obj = { api = "get_record_base", data = {} }
	local resp = utl.ubus("hosd", "common", req_obj) or {code = 1}
	http.prepare_content("application/json")
	http.write(json.stringify(resp))
end
function set_record_base()
	local json = require "luci.jsonc"
	local http = require "luci.http"
	local utl  = require "luci.util"
	local enable = tonumber(http.formvalue("enable") or 0) or 0
	local record_time = tonumber(http.formvalue("record_time") or 0) or 0
	local app_valid_time = tonumber(http.formvalue("app_valid_time") or 0) or 0
	local history_data_size = http.formvalue("history_data_size") or ""
	local history_data_path = http.formvalue("history_data_path") or ""
	
	if record_time < 0 then record_time = 0 end
	if app_valid_time < 0 then app_valid_time = 0 end
	if history_data_size and history_data_size ~= "" then
		local size_num = tonumber(history_data_size)
		if not size_num or size_num < 1 or size_num > 1024 or size_num ~= math.floor(size_num) then
			http.prepare_content("application/json")
			http.write(json.stringify({code = 1, msg = "History data size must be an integer between 1 and 1024 MB"}))
			return
		end
	end
	if not history_data_path or history_data_path == "" or history_data_path == "/" then
		http.prepare_content("application/json")
		http.write(json.stringify({code = 1, msg = "History data path cannot be empty or /"}))
		return
	end
	if #history_data_path > 64 then
		http.prepare_content("application/json")
		http.write(json.stringify({code = 1, msg = "History data path maximum length is 64 characters"}))
		return
	end
	local req_obj = {
		api = "set_record_base",
		data = {
			enable = enable,
			record_time = record_time,
			app_valid_time = app_valid_time,
			history_data_size = history_data_size,
			history_data_path = history_data_path
		}
	}
	local resp = utl.ubus("hosd", "common", req_obj) or {code = 1}
	http.prepare_content("application/json")
	http.write(json.stringify(resp))
end
function record_action()
	local json = require "luci.jsonc"
	local http = require "luci.http"
	local utl  = require "luci.util"
	local action = http.formvalue("action") or ""
	
	local req_obj = {
		api = "record_action",
		data = {
			action = action
		}
	}
	local resp = utl.ubus("hosd", "common", req_obj) or {code = 1}
	http.prepare_content("application/json")
	http.write(json.stringify(resp))
end
