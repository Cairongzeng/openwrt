module("luci.controller.feature", package.seeall)

function index()
	entry({"admin", "parental", "feature"},
		cbi("feature/feature", {hideapplybtn=true, hidesavebtn=true, hideresetbtn=true}),
		_("Feature"), 82).dependent = true
	entry({"admin", "advance", "feature", "info"}, call("get_feature_info"), nil).leaf = true
	entry({"admin", "advance", "feature", "class_list"}, call("get_feature_class_list"), nil).leaf = true
	entry({"admin", "advance", "feature", "upgrade_status"}, call("get_feature_upgrade_status"), nil).leaf = true
end

function get_feature_upgrade_status()
	local fs   = require "nixio.fs"
	local json = require "luci.jsonc"
	local http = require "luci.http"

	local status_file = "/tmp/feature_upgrade.status"
	local status = 0

	if fs.access(status_file) then
		local content = fs.readfile(status_file) or ""
		status = tonumber(content:match("(%d+)")) or 0
		fs.writefile(status_file, "0")
	end

	http.prepare_content("application/json")
	http.write(json.stringify({code = 0, status = status}))
end

function get_feature_info()
	local json = require "luci.jsonc"
	local nfs = require "nixio.fs"
	local sys = require "luci.sys"
	luci.http.prepare_content("application/json")

	local info = {
		version = "",
		format = "v3.0",
		app_count = 0
	}

	if nfs.access("/tmp/feature.cfg") then
		info.app_count = tonumber(sys.exec("cat /tmp/feature.cfg | grep -v ^$ |grep -v ^# | wc -l")) or 0
		info.version = sys.exec("cat /tmp/feature.cfg |grep \"#version\" | awk '{print $2}'") or ""
	end

	luci.http.write(json.stringify({code = 0, data = info, message = "success"}))
end

function get_feature_class_list()
	local json = require "luci.jsonc"
	local utl = require "luci.util"
	luci.http.prepare_content("application/json")
	
	local req_obj = {}
	req_obj.api = "class_list"
	req_obj.data = {}
	
	local resp_obj = utl.ubus("hos", "common", req_obj)
	
	if resp_obj and resp_obj.code == 2000 and resp_obj.data then
		luci.http.write(json.stringify(resp_obj.data))
	else
		luci.http.write(json.stringify({class_list = {}}))
	end
end