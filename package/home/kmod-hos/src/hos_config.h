// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef __FWX_CONFIG_H__
#define __FWX_CONFIG_H__
#include "k_json.h"
#define FWX_CHAR_DEV "hos"
typedef int (*k_request_handler)(cJSON *data_obj);
typedef struct k_request_item{
    const char *api;
    k_request_handler handle;
}k_request_item_t;

int hos_register_dev(void);
void hos_unregister_dev(void);
#endif
