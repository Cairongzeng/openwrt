// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef __AF_DEBUG_H__
#define __AF_DEBUG_H__
extern int hos_test_mode;
extern int af_work_mode;
extern int g_app_filter_enable;
extern int g_record_enable;
extern int g_by_pass_accl;
extern unsigned int hos_lan_ip;
extern unsigned int hos_lan_mask;
extern int g_feature_init;
extern int g_user_mode;
extern char g_lan_ifname[64];
extern int g_tcp_rst;
extern int g_feature_count;

#define TEST_MODE() (hos_test_mode)
int af_log_init(void);
int af_log_exit(void);
#endif
