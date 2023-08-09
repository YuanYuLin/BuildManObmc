SUMMARY = "OpenBMC - Applications"
PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
        ${PN}-chassis \
        ${PN}-fans \
        ${PN}-flash \
        ${PN}-system \
        "

PROVIDES += "virtual/obmc-chassis-mgmt"
PROVIDES += "virtual/obmc-fan-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"

RPROVIDES:${PN}-chassis += "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-fans += "virtual-obmc-fan-mgmt"
RPROVIDES:${PN}-flash += "virtual-obmc-flash-mgmt"
RPROVIDES:${PN}-system += "virtual-obmc-system-mgmt"

SUMMARY:${PN}-chassis = " Chassis"
RDEPENDS:${PN}-chassis = " \
        "

SUMMARY:${PN}-fans = " Fans"
RDEPENDS:${PN}-fans = " \
        "

SUMMARY:${PN}-flash = " Flash"
RDEPENDS:${PN}-flash = " \
        phosphor-ipmi-flash \
        "

SUMMARY:${PN}-system = " System"
RDEPENDS:${PN}-system = " \
        bmcweb \
	webui-vue \
        "
