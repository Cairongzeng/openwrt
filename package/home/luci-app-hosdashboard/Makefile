
include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for hos dashboard
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+hosd +kmod-hos +luci-compat +luci-app-hosappfilter
PKG_NAME:=luci-app-hosdashboard
PKG_VERSION:=2.0
PKG_RELEASE:=1
include $(TOPDIR)/feeds/luci/luci.mk
# call BuildPackage - OpenWrt buildroot signature
