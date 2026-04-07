// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef __FWX_UCI_H__
#define __FWX_UCI_H__
#include <uci.h>

#define MAX_PARAM_LIST_LEN 1024

int hos_uci_get_int_value(struct uci_context *ctx, char *key);
int hos_uci_get_value(struct uci_context *ctx, char *key, char *output, int out_len);
int hos_uci_add_list(struct uci_context *ctx, char *key, char *value);
int hos_uci_get_list_value(struct uci_context *ctx, char *key, char *output, int out_len, char *delimt);
int hos_uci_add_int_list(struct uci_context *ctx, char *key, int value);
int hos_uci_del_list(struct uci_context *ctx, char *key, char *value);
int hos_uci_set_value(struct uci_context *ctx, char *key, char *value);
int hos_uci_set_int_value(struct uci_context *ctx, char *key, int value);
int hos_uci_del_array_value(struct uci_context *ctx, char *key_fmt, int index);
int hos_uci_set_array_value(struct uci_context *ctx, char *key_fmt, int index, char *value);
int hos_uci_get_list_num(struct uci_context * ctx, char *package, char *section);
int hos_uci_get_array_value(struct uci_context *ctx, char *key_fmt, int index, char *output, int out_len);
int hos_uci_add_section(struct uci_context * ctx, char *package_name, char *section);
int hos_uci_commit(struct uci_context *ctx, const char * package);
int hos_uci_delete(struct uci_context *ctx, char *key);
#endif

