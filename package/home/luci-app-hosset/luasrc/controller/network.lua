module("luci.controller.network", package.seeall)

local uci = require("luci.model.uci").cursor()
local util = require("luci.util")

function index()
    entry({"admin", "settings"}, firstchild(), _("Network Setting"), 29).dependent = true

    entry({"admin", "settings", "lan"}, template("network/lan"), _("LAN Setting"), 20).dependent = true
    entry({"admin", "settings", "wan"}, template("network/wan"), _("WAN Setting"), 30).dependent = true
    entry({"admin", "settings", "work_mode"}, template("network/work_mode"), _("Work Mode"), 10).dependent = true

    entry({"admin", "network", "get_lan_info"}, call("api_get_lan"), nil).leaf = true
    entry({"admin", "network", "set_lan_info"}, call("api_set_lan"), nil).leaf = true
    entry({"admin", "network", "get_wan_info"}, call("api_get_wan"), nil).leaf = true
    entry({"admin", "network", "set_wan_info"}, call("api_set_wan"), nil).leaf = true
    entry({"admin", "network", "get_work_mode"}, call("api_get_work_mode"), nil).leaf = true
    entry({"admin", "network", "set_work_mode"}, call("api_set_work_mode"), nil).leaf = true
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
    return util.ubus("fwx", "common", payload) or { code = 1 }
end

function api_get_lan()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    local resp = ubus_call("get_lan_info", { data = {} })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end


function api_set_lan()
    local json = require "luci.jsonc" 
    local http = require "luci.http"
    local body = {
        proto   = http.formvalue("proto")   or "",
        ipaddr  = http.formvalue("ipaddr")  or "",
        netmask = http.formvalue("netmask") or "",
        gateway = http.formvalue("gateway") or "",
        dns1    = http.formvalue("dns1")    or "",
        dns2    = http.formvalue("dns2")    or ""
    }
    local dhcp_enable    = tonumber(http.formvalue("dhcp.enable") or http.formvalue("dhcp_enable") or http.formvalue("enable") or 0) or 0
    local dhcp_start     = tonumber(http.formvalue("dhcp.start") or http.formvalue("dhcp_start") or http.formvalue("start") or 0) or 0
    local dhcp_limit     = tonumber(http.formvalue("dhcp.limit") or http.formvalue("dhcp_limit") or http.formvalue("limit") or 0) or 0
    local dhcp_leasetime = tonumber(http.formvalue("dhcp.leasetime") or http.formvalue("dhcp_leasetime") or http.formvalue("leasetime") or 0) or 0
    body.dhcp = {
        enable   = dhcp_enable,
        start    = dhcp_start,
        limit    = dhcp_limit,
        leasetime= dhcp_leasetime
    }

    local empty_form = (body.proto == "" and body.ipaddr == "" and body.netmask == "" and body.gateway == "" and body.dns1 == "" and body.dns2 == "" and dhcp_start == 0 and dhcp_limit == 0 and dhcp_leasetime == 0 and dhcp_enable == 0)
    if empty_form then
        local jd = http.jsondata()
        if jd and next(jd) then
            body = jd
        else
            local data_str = http.formvalue("data")
            if data_str and #data_str > 0 then
                body = json.parse(data_str) or body
            end
        end
    end
    local resp = ubus_call("set_lan_info", { data = body or {} })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end


function api_get_wan()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    local resp = ubus_call("get_wan_info", { data = {} })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end

function api_set_wan()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    local body = {
        proto   = http.formvalue("proto")   or "",
        ipaddr  = http.formvalue("ipaddr")  or "",
        netmask = http.formvalue("netmask") or "",
        gateway = http.formvalue("gateway") or "",
        dns1    = http.formvalue("dns1")    or "",
        dns2    = http.formvalue("dns2")    or "",
        username = http.formvalue("username") or "",
        password = http.formvalue("password") or ""
    }
    local empty_form = (body.proto == "" and body.ipaddr == "" and body.netmask == "" and body.gateway == "" and body.dns1 == "" and body.dns2 == "" and body.username == "" and body.password == "")
    if empty_form then
        local jd = http.jsondata()
        if jd and next(jd) then
            body = jd
        else
            local data_str = http.formvalue("data")
            if data_str and #data_str > 0 then
                body = json.parse(data_str) or body
            end
        end
    end
    local resp = ubus_call("set_wan_info", { data = body or {} })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end

function api_get_work_mode()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    local resp = ubus_call("get_work_mode", { data = {} })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end


function api_set_work_mode()
    local json = require "luci.jsonc"
    local http = require "luci.http"
    local wm = tonumber(http.formvalue("work_mode") or 0) or 0
    local body = { work_mode = wm }

    local resp = ubus_call("set_work_mode", { data = body or {} })
    http.prepare_content("application/json")
    http.write(json.stringify(resp))
end

