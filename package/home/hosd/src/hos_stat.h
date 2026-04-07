// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef __FWX_STAT_H__
#define __FWX_STAT_H__

#include <json-c/json.h>

int hos_stat_read_conntrack_count(void);
void hos_session_stat_tick(void);
struct json_object *hos_api_get_history_session(struct json_object *req_obj);

#endif
