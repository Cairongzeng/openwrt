module("luci.controller.dashboard", package.seeall)

function index()
        entry({"admin", "parental", "dashboard"}, cbi("dashboard/dashboard", {hideapplybtn=true, hidesavebtn=true, hideresetbtn=true}), _("Dashboard"), 0).leaf = true

        entry({"admin", "dashboard_api", "get_dashboard_common"}, call("get_dashboard_common")).leaf = true
        entry({"admin", "dashboard_api", "get_daily_top_users"}, call("get_daily_top_users")).leaf = true
        entry({"admin", "dashboard_api", "get_active_users"}, call("get_active_users")).leaf = true
        entry({"admin", "dashboard_api", "get_app_type_stats"}, call("get_app_type_stats")).leaf = true
end

function get_dashboard_common()
        local json = require "luci.jsonc"
        local utl = require "luci.util"

        luci.http.prepare_content("application/json")

        local req_obj = {}
        req_obj.api = "get_dashboard_common"
        local resp_obj = utl.ubus("hos", "common", req_obj)
        if resp_obj and resp_obj.code == 0 then
                luci.http.write(json.stringify(resp_obj.data))
        else
                luci.http.write(json.stringify({}))
        end
end

function get_daily_top_users()
        local json = require "luci.jsonc"
        local utl = require "luci.util"

        luci.http.prepare_content("application/json")

        local req_obj = {}
        req_obj.api = "get_daily_top_users"
        local resp_obj = utl.ubus("hos", "common", req_obj)
        if resp_obj and resp_obj.code == 0 then
                luci.http.write(json.stringify(resp_obj.data))
        else
                luci.http.write(json.stringify({}))
        end
end

function get_active_users()
        local json = require "luci.jsonc"
        local utl = require "luci.util"

        luci.http.prepare_content("application/json")

        local req_obj = {}
        req_obj.api = "get_active_users"
        local resp_obj = utl.ubus("hos", "common", req_obj)
        if resp_obj and resp_obj.code == 0 then
                luci.http.write(json.stringify(resp_obj.data))
        else
                luci.http.write(json.stringify({}))
        end
end

function get_app_type_stats()
        local json = require "luci.jsonc"
        local utl = require "luci.util"

        luci.http.prepare_content("application/json")

        local req_obj = {}
        req_obj.api = "get_app_type_stats"
        local resp_obj = utl.ubus("hos", "common", req_obj)
        if resp_obj and resp_obj.code == 0 then
                luci.http.write(json.stringify(resp_obj.data))
        else
                luci.http.write(json.stringify({}))
        end
end
