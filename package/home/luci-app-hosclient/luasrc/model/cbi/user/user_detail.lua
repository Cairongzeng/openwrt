-- SPDX-License-Identifier: GPL-3.0-or-later
-- Copyright (C) 2025-2026 Rongzeng Cai <cairongzeng@outlook.com>
local ds = require "luci.dispatcher"
local m, s

m = Map("hosparental", translate(""), translate(""))

m:section(SimpleSection).template = "hosclient/user_detail"

return m

