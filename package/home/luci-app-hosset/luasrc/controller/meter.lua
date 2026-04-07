-- SPDX-License-Identifier: GPL-3.0-or-later
-- Copyright (C) 2025-2026 Rongzeng Cai <cairongzeng@outlook.com>
module("luci.controller.meter", package.seeall)
local uci = require("luci.model.uci").cursor()
local util = require("luci.util")
function index()
    entry({"admin", "app", "get_device_list"}, call("api_get_device_list"), nil).leaf = true
    entry({"admin", "app", "get_dashboard_param"}, call("api_get_dashboard_param"), nil).leaf = true
    entry({"admin", "app", "set_dashboard_param"}, call("api_set_dashboard_param"), nil).leaf = true
end
function llog(message)
    local log_file = "/tmp/log/luci.log"  
    local fd = io.open(log_file, "a")  
    if fd then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S") 
        fd:write(string.format("[%s] %s\n", timestamp, message)) 
        fd:close() 
    end
end
local function ubus_call(api, payload)
    payload = payload or {}
    payload.api = api
    return util.ubus("hosd", "common", payload) or { code = 1 }
end
function api_get_device_list()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    llog("api_get_device_list")
    local resp = ubus_call("get_device_list", { data = {} })
    llog("api_get_device_list resp: "..json.stringify(resp))
    http.prepare_content("application/json")
    llog("api_get_device_list http.write: "..json.stringify(resp))
    http.write(json.stringify(resp))
end
function api_get_dashboard_param()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    local resp = ubus_call("get_dashboard_param", { data = {} })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end
function api_set_dashboard_param()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    local monitor_device = http.formvalue("monitor_device") or ""
    local body = {
        monitor_device = monitor_device
    }
    local resp = ubus_call("set_dashboard_param", { data = body })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end
