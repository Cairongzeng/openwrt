-- SPDX-License-Identifier: GPL-3.0-or-later
-- Copyright (C) 2025-2026 Rongzeng Cai <cairongzeng@outlook.com>
local ds = require "luci.dispatcher"
local nxo = require "nixio"
local nfs = require "nixio.fs"
local ipc = require "luci.ip"
local sys = require "luci.sys"
local utl = require "luci.util"
local dsp = require "luci.dispatcher"
local uci = require "luci.model.uci"
local lng = require "luci.i18n"
local jsc = require "luci.jsonc"
local http = luci.http
local SYS = require "luci.sys"
local m, s
m = Map("hosparental", translate(""), translate(""))
m:section(SimpleSection).template = "hosclient/user_status"
return m
