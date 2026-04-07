
include $(TOPDIR)/rules.mk

LUCI_TITLE:=HOS Theme
PKG_NAME:=luci-theme-hos
PKG_VERSION:=2.0
PKG_RELEASE:=1

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-theme-hos/postrm
#!/bin/sh
uci -q delete luci.themes.HOS
uci commit luci
/etc/init.d/uhttpd restart
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature