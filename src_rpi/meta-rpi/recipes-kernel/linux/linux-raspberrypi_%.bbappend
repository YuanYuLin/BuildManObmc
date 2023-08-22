FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KERNEL_DEVICETREE = "bcm2708-rpi-b-plus.dtb"

#SRC_URI += "file://0001-Kconfig.patch"
#SRC_URI += "file://0002-Makefile.patch"
#SRC_URI += "file://0003-lenovo-ps.c.patch"
#SRC_URI += "file://0004-bcm2708-rpi-b-plus.dts.patch"
#SRC_URI += "file://0005-bcm2835-rpi.dtsi.patch"
#SRC_URI += "file://0006-bcm283x.dtsi.patch"
#SRC_URI += "file://0007-i2c-core-base.c.patch"
#SRC_URI += "file://0008-bcm2835.dtsi.patch"
SRC_URI += "file://rpi.cfg"
