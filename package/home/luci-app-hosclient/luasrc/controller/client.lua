-- SPDX-License-Identifier: GPL-3.0-or-later
-- Copyright (C) 2025-2026 Rongzeng Cai <cairongzeng@outlook.com>
module("luci.controller.client", package.seeall)
local utl = require "luci.util"
function index()
        entry({"admin", "parental", "client"}, cbi("user/user_status", {hideapplybtn=true, hidesavebtn=true, hideresetbtn=true}), _("Clients"), 83).leaf = true
        entry({"admin", "parental", "hosclient", "detail"}, cbi("user/user_detail", {hideapplybtn=true, hidesavebtn=true, hideresetbtn=true}), nil).leaf = true
        entry({"admin", "hosd", "user_status"}, call("user_status"), nil).leaf = true
        entry({"admin", "hosd", "dev_visit_list"}, call("get_dev_visit_list"), nil).leaf = true
        entry({"admin", "hosd", "dev_visit_time"}, call("get_dev_visit_time"), nil).leaf = true
        entry({"admin", "hosd", "app_class_visit_time"}, call("get_app_class_visit_time"), nil).leaf = true
        entry({"admin", "hosd", "get_all_users"}, call("get_all_users"), nil).leaf = true
        entry({"admin", "hosd", "set_nickname"}, call("set_nickname"), nil).leaf = true
        entry({"admin", "hosd", "get_hourly_stats"}, call("get_hourly_stats"), nil).leaf = true
        entry({"admin", "hosd", "get_user_basic_info"}, call("get_user_basic_info"), nil).leaf = true
        entry({"admin", "hosd", "get_online_offline_records"}, call("get_online_offline_records"), nil).leaf = true
end
function get_hostname_by_mac(dst_mac)
    leasefile="/tmp/dhcp.leases"
    local fd = io.open(leasefile, "r")
	if not fd then return end
    while true do
        local ln = fd:read("*l")
        if not ln then
            break
        end
        local ts, mac, ip, name, duid = ln:match("^(%d+) (%S+) (%S+) (%S+) (%S+)")
        if  dst_mac == mac then
            fd:close()
            return name
        end
    end
	fd:close()
    return ""
end
function get_app_name_by_id(appid)
	local class_fd = io.popen("find /tmp/hosparental/ -type f -name *.class |xargs cat |grep "..appid.."|awk '{print $2}'")
	if class_fd then
		local name = class_fd:read("*l")
		class_fd:close()
		return name
	end
	return ""
end
function cmp_func(a,b)
	return a.latest_time > b.latest_time
end
function user_status()
	local json = require "luci.jsonc"
	luci.http.prepare_content("application/json")
	local fd = io.open("/proc/net/af_client","r")
	status_buf=fd:read('*a')
	fd:close()
	user_array=json.parse(status_buf)
	
	local req_obj = {}
	req_obj.api = "visit_list"
	req_obj.data = {}
	local visit_obj = utl.ubus("hos", "common", req_obj)
	
	local user_array = {}
	if visit_obj and visit_obj.code == 2000 and visit_obj.data and visit_obj.data.dev_list then
		user_array = visit_obj.data.dev_list
	end
	local history={}
	for i, v in pairs(user_array) do
		visit_array=user_array[i].visit_info
		for j,s in pairs(visit_array) do
			total_time=visit_array[j].latest_time - visit_array[j].first_time;
			history[#history+1]={
				mac=user_array[i].mac,
				ip=user_array[i].ip,
				hostname=get_hostname_by_mac(user_array[i].mac),
				appid=visit_array[j].appid,
				appname=get_app_name_by_id(visit_array[j].appid),
				total_num=0,
				drop_num=0,
				latest_action=visit_array[j].latest_action,
				latest_time=os.date("%Y/%m/%d %H:%M:%S", visit_array[j].latest_time),
				first_time=os.date("%Y/%m/%d %H:%M:%S", visit_array[j].first_time),
				total_time=total_time
			}
		end
	end
	table.sort(history, cmp_func)
	luci.http.write_json(history);
end
function get_all_users()
	local json = require "luci.jsonc"
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "get_all_users"
	req_obj.data = {
		flag = luci.http.formvalue("flag"),
		page = luci.http.formvalue("page")
	}
	
	local resp_obj = utl.ubus("hos", "common", req_obj)
	
	if resp_obj and resp_obj.code == 2000 and resp_obj.data then
		luci.http.write_json({data = resp_obj.data})
	else
		luci.http.write_json({data = resp_obj or {}})
	end
end
function get_oaf_status()
	local json = require "luci.jsonc"
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "get_oaf_status"
	req_obj.data = {}
	
	local resp_obj = utl.ubus("hos", "common", req_obj)
	
	if resp_obj and resp_obj.code == 2000 and resp_obj.data then
		luci.http.write_json(resp_obj.data)
	else
		luci.http.write_json(resp_obj or {})
	end
end
function set_nickname()
	local json = require "luci.jsonc"
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "set_nickname"
	req_obj.data = {
		mac = luci.http.formvalue("mac"),
		nickname = luci.http.formvalue("nickname")
	}
	
	local resp_obj = utl.ubus("hos", "common", req_obj);
	
	if resp_obj and resp_obj.code == 2000 then
		luci.http.write_json(resp_obj.data or {})
	else
		luci.http.write_json(resp_obj or {})
	end
end
function get_dev_visit_time(mac)
	local json = require "luci.jsonc"
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "dev_visit_time"
	req_obj.data = {
		mac = mac
	}
	
	local visit_obj = utl.ubus("hos", "common", req_obj)
	
	local visit_list = {}
	if visit_obj and visit_obj.code == 2000 and visit_obj.data and visit_obj.data.list then
		visit_list = visit_obj.data.list
	end
	luci.http.write_json(visit_list)
end
function get_app_class_visit_time(mac)
	local json = require "luci.jsonc"
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "app_class_visit_time"
	req_obj.data = {
		mac = mac
	}
	
	local visit_obj = utl.ubus("hos", "common", req_obj)
	
	local class_array = {}
	if visit_obj and visit_obj.code == 2000 and visit_obj.data and visit_obj.data.class_list then
		class_array = visit_obj.data.class_list
	end
	luci.http.write_json(class_array)
end
function get_dev_visit_list(mac)
	local json = require "luci.jsonc"
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "dev_visit_list"
	req_obj.data = {
		mac = mac
	}
	
	local page = luci.http.formvalue("page")
	local page_size = luci.http.formvalue("page_size")
	if page then
		req_obj.data.page = tonumber(page) or 1
	end
	if page_size then
		req_obj.data.page_size = tonumber(page_size) or 15
	end
	
	local resp_obj = utl.ubus("hos", "common", req_obj)
	
	if resp_obj and resp_obj.code == 2000 and resp_obj.data then
		luci.http.write_json(resp_obj.data)
	else
		luci.http.write_json(resp_obj or {})
	end
end
function get_hourly_stats(mac)
	local json = require "luci.jsonc"
	local utl = require "luci.util"
	
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "get_hourly_top_apps"
	req_obj.data = {
		mac = mac
	}
	
	local resp_obj = utl.ubus("hos", "common", req_obj)
	
	if resp_obj and resp_obj.code == 2000 and resp_obj.data then
		luci.http.write_json(resp_obj.data)
	else
		luci.http.write_json({
			mac = mac,
			date = 0,
			is_today = 1,
			hourly_stats = {}
		})
	end
end
function get_user_basic_info(mac)
	local json = require "luci.jsonc"
	local utl = require "luci.util"
	
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "get_user_basic_info"
	req_obj.data = {
		mac = mac
	}
	
	local resp_obj = utl.ubus("hos", "common", req_obj)
	
	if resp_obj and resp_obj.code == 2000 and resp_obj.data then
		luci.http.write_json(resp_obj.data)
	else
		luci.http.write_json({})
	end
end
