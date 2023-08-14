FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Kconfig.patch"
SRC_URI += "file://0002-Makefile.patch"
SRC_URI += "file://0003-lenovo-ps.c.patch"
SRC_URI += "file://0004-bcm2708-rpi-b-plus.dts.patch"
SRC_URI += "file://0005-bcm2835-rpi.dtsi.patch"
SRC_URI += "file://rpi.cfg"
