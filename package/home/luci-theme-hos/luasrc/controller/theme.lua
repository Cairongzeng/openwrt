module("luci.controller.theme", package.seeall)
-- Copyright (C) 2025-2026 Rongzeng Cai <cairongzeng@outlook.com>

local uci = require("luci.model.uci").cursor()
local json = require("luci.jsonc")
local http = require("luci.http")

function index()
    entry({"admin", "app", "theme_mode"}, call("handle_theme"), nil).leaf = true
end

function handle_theme()
    local method = http.formvalue("_method") or "GET"
    if method == "POST" then
        set_theme()
    else
        get_theme()
    end
end

function get_theme()
    local mode = uci:get_first("hos", "global", "theme_mode") or "0"
    http.prepare_content("application/json")
    http.write(json.stringify({ code = 0, mode = mode }))
end

function set_theme()
    local mode = http.formvalue("mode")
    if mode == "1" or mode == "0" then
        uci:set("hos", "global", "theme_mode", mode)
        uci:commit("hos")
        http.redirect(http.getenv("HTTP_REFERER") or "/cgi-bin/luci")
    else
        http.status(400)
        http.prepare_content("application/json")
        http.write(json.stringify({ code = 1, message = "Invalid mode" }))
    end
end
