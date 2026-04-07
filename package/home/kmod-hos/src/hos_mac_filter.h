// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef __FWX_MAC_FILTER_H__
#define __FWX_MAC_FILTER_H__
#include "k_json.h"
#include "hos_mac.h"
#include <linux/list.h>

#define MAX_MAC_FILTER_RULE_NUM 64

typedef struct mac_filter_rule {
    int rule_id;                 // 规则ID
    mac_config_t mac_list;      // MAC地址列表
    struct list_head list;      // 链表节点
} mac_filter_rule_t;

extern int g_mac_filter_enable;

int hos_api_add_mac_filter_whitelist(cJSON *data_obj);
int hos_api_del_mac_filter_whitelist(cJSON *data_obj);
int hos_api_flush_mac_filter_whitelist(cJSON *data_obj);

int hos_match_mac_filter_whitelist(const unsigned char *mac);

int hos_mac_filter_init(void);

void hos_mac_filter_exit(void);

int hos_add_mac_filter_rule(int rule_id);

int hos_del_mac_filter_rule(int rule_id);

mac_filter_rule_t *hos_find_mac_filter_rule(int rule_id);

int hos_add_mac_to_rule(int rule_id, const unsigned char *mac);

int hos_del_mac_from_rule(int rule_id, const unsigned char *mac);

mac_filter_rule_t *hos_match_mac_filter_rule(const unsigned char *mac);

int hos_api_add_mac_filter_rule(cJSON *data_obj);

int hos_api_del_mac_filter_rule(cJSON *data_obj);

int hos_api_dump_mac_filter_rule(cJSON *data_obj);

int hos_api_flush_mac_filter_rule(cJSON *data_obj);

int hos_api_mod_mac_filter_rule(cJSON *data_obj);

#endif 