
include $(TOPDIR)/rules.mk

LUCI_TITLE:=HomeOS Theme
LUCI_DEPENDS:=+luci-base +@LUCI_LANG_zh_Hans +luci-i18n-base-zh-cn
PKG_LICENSE:=Apache-2.0

define Package/luci-theme-homeos/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	uci -q delete luci.themes.Bootstrap
	uci -q delete luci.themes.BootstrapDark
	uci -q delete luci.themes.BootstrapLight
	uci commit luci
}
endef

include $(TOPDIR)/feeds/luci/luci.mk
# call BuildPackage - OpenWrt buildroot signature