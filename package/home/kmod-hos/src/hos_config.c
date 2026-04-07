// SPDX-License-Identifier: GPL-2.0-or-later
#include <linux/init.h>
#include <linux/module.h>
#include <net/tcp.h>
#include <linux/netfilter.h>
#include <net/netfilter/nf_conntrack.h>
#include <linux/skbuff.h>
#include <net/ip.h>
#include <linux/types.h>
#include <net/sock.h>
#include <linux/etherdevice.h>
#include <linux/cdev.h>
#include <linux/vmalloc.h>
#include <linux/device.h>
#include <linux/version.h>
#include "hos_config.h"
#include "k_json.h"
#include "hos.h"
#include "hos_mac_filter.h"
#include "hos_app_filter.h"
static struct mutex hos_cdev_mutex;
struct hos_config_dev
{
	dev_t id;
	struct cdev char_dev;
	struct class *c;
};
struct hos_config_dev g_hos_dev;

struct hos_cdev_file
{
	size_t size;
	char buf[256 << 10];
};

k_request_item_t k_request_api_list[]={
	{"add_mac_filter_rule", hos_api_add_mac_filter_rule},
	{"del_mac_filter_rule", hos_api_del_mac_filter_rule},
	{"mod_mac_filter_rule", hos_api_mod_mac_filter_rule},
	{"dump_mac_filter_rule", hos_api_dump_mac_filter_rule},
	{"flush_mac_filter_rule", hos_api_flush_mac_filter_rule},
	{"add_app_filter_rule", hos_api_add_app_filter_rule},
	{"del_app_filter_rule", hos_api_del_app_filter_rule},
	{"mod_app_filter_rule", hos_api_mod_app_filter_rule},
	{"dump_app_filter_rule", hos_api_dump_app_filter_rule},
	{"flush_app_filter_rule", hos_api_flush_app_filter_rule},
	{"add_mac_filter_whitelist", hos_api_add_mac_filter_whitelist},
	{"del_mac_filter_whitelist", hos_api_del_mac_filter_whitelist},
	{"flush_mac_filter_whitelist", hos_api_flush_mac_filter_whitelist},
	{"add_app_filter_whitelist", hos_api_add_app_filter_whitelist},
	{"flush_app_filter_whitelist", hos_api_flush_app_filter_whitelist},
};

int hos_config_handle(char *config, unsigned int len)
{
	int i;
	cJSON *config_obj = NULL;
	cJSON *api_obj = NULL;
	cJSON *data_obj = NULL;
	if (!config || len == 0)
		return -1;
	
	config_obj = cJSON_Parse(config);
	if (!config_obj){
		printk("parse json failed, value = %s\n", config);
		return -1;
	}
	api_obj = cJSON_GetObjectItem(config_obj, "api");
	data_obj = cJSON_GetObjectItem(config_obj, "data");
	if (!api_obj){
		printk("error, api obj not set\n");
		cJSON_Delete(config_obj);
		return -1;
	}

	cJSON *temp_data_obj = NULL;
	if (!data_obj){
		temp_data_obj = cJSON_CreateObject();  // 创建一个空的data对象
		data_obj = temp_data_obj;
	}

	for (i = 0; i < ARRAY_SIZE(k_request_api_list); i++){
		k_request_item_t *req_item = &k_request_api_list[i];
		if (0 == strcmp(req_item->api, api_obj->valuestring)){
			req_item->handle(data_obj);
			break;
		}
	}
	

	if (temp_data_obj){
		cJSON_Delete(temp_data_obj);
	}
	cJSON_Delete(config_obj);
	return 0;
}

static int hos_cdev_open(struct inode *inode, struct file *filp)
{
	struct hos_cdev_file *file;
	file = vzalloc(sizeof(*file));
	if (!file)
		return -EINVAL;

	mutex_lock(&hos_cdev_mutex);
	filp->private_data = file;
	return 0;
}

static ssize_t hos_cdev_read(struct file *filp, char *buf, size_t count, loff_t *off)
{
	return 0;
}

static int hos_cdev_release(struct inode *inode, struct file *filp)
{
	struct hos_cdev_file *file = filp->private_data;
	hos_config_handle(file->buf, file->size);
	filp->private_data = NULL;
	mutex_unlock(&hos_cdev_mutex);
	vfree(file);
	return 0;
}

static ssize_t hos_cdev_write(struct file *filp, const char *buffer, size_t count, loff_t *off)
{
	struct hos_cdev_file *file = filp->private_data;
	int ret;
	if (file->size + count > sizeof(file->buf))
		return -EINVAL;

	ret = copy_from_user(file->buf + file->size, buffer, count);
	if (ret != 0)
		return -EINVAL;

	file->size += count;
	return count;
}

static struct file_operations hos_cdev_ops = {
	owner : THIS_MODULE,
	release : hos_cdev_release,
	open : hos_cdev_open,
	write : hos_cdev_write,
	read : hos_cdev_read,
};

int hos_register_dev(void)
{
	struct device *dev;
	int res;
	mutex_init(&hos_cdev_mutex);

	res = alloc_chrdev_region(&g_hos_dev.id, 0, 1, FWX_CHAR_DEV);
	if (res != 0)
		return -EINVAL;

	cdev_init(&g_hos_dev.char_dev, &hos_cdev_ops);
	res = cdev_add(&g_hos_dev.char_dev, g_hos_dev.id, 1);
	if (res < 0)
		goto REGION_OUT;
#if LINUX_VERSION_CODE < KERNEL_VERSION(6, 4, 0)
	g_hos_dev.c = class_create(THIS_MODULE, FWX_CHAR_DEV);
#else
 	g_hos_dev.c = class_create(FWX_CHAR_DEV);
#endif

	if (IS_ERR_OR_NULL(g_hos_dev.c))
		goto CDEV_OUT;

	dev = device_create(g_hos_dev.c, NULL, g_hos_dev.id, NULL, FWX_CHAR_DEV);
	if (IS_ERR_OR_NULL(dev))
		goto CLASS_OUT;
	return 0;

CLASS_OUT:
	class_destroy(g_hos_dev.c);
CDEV_OUT:
	cdev_del(&g_hos_dev.char_dev);
REGION_OUT:
	unregister_chrdev_region(g_hos_dev.id, 1);
	printk("register char dev....fail\n");
	return -EINVAL;
}

void hos_unregister_dev(void)
{
	device_destroy(g_hos_dev.c, g_hos_dev.id);
	class_destroy(g_hos_dev.c);
	cdev_del(&g_hos_dev.char_dev);
	unregister_chrdev_region(g_hos_dev.id, 1);
}

