// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef __FWX_MAC_FILTER_H__
#define __FWX_MAC_FILTER_H__

#include "hos.h"

struct json_object *hos_api_get_mac_filter_rules(struct json_object *req_obj);
struct json_object *hos_api_add_mac_filter_rule(struct json_object *req_obj);
struct json_object *hos_api_update_mac_filter_rule(struct json_object *req_obj);
struct json_object *hos_api_delete_mac_filter_rule(struct json_object *req_obj);

struct json_object *hos_api_get_mac_filter_whitelist(struct json_object *req_obj);
struct json_object *hos_api_add_mac_filter_whitelist(struct json_object *req_obj);
struct json_object *hos_api_del_mac_filter_whitelist(struct json_object *req_obj);

struct json_object *hos_api_get_mac_filter_adv(struct json_object *req_obj);
struct json_object *hos_api_set_mac_filter_adv(struct json_object *req_obj);

#endif

