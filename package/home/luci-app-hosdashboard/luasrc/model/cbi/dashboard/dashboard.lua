local jsc = require "luci.jsonc"

local m, s
m = Map("hos_dashboard", translate(""), translate(""))

local v
v = m:section(SimpleSection)
v.template = "hos_dashboard/dashboard"
return m
