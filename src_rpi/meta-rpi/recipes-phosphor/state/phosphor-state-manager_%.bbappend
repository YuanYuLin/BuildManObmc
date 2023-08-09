# IBM systems only want power restore when AC loss occurred
EXTRA_OEMESON:append = " -Donly-run-apr-on-power-loss=true"

# The scheduled-host-transition package provides support to
# schedule power on and off operations for the host at some
# time in the future. IBM systems will utilize this feature
RRECOMMENDS:${PN}-host:append = " ${PN}-scheduled-host-transition"

# IBM systems track the state of the hypervisor so bring
# in the needed package when the host state package is
# included
RRECOMMENDS:${PN}-host:append = " ${PN}-hypervisor"

# IBM systems want the chassis package to not allow a
# system power on if chassis power is in a bad state
RRECOMMENDS:${PN}-chassis:append = " ${PN}-chassis-check-power-status"

# Override critical services to monitor with IBM file
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILES:${PN}-bmc:append = " ${sysconfdir}/phosphor-service-monitor-default.json"
SRC_URI:append = " file://phosphor-service-monitor-default.json"
do_install:append() {
    install -d ${D}${sysconfdir}/phosphor-systemd-target-monitor
    install -m 0644 ${WORKDIR}/phosphor-service-monitor-default.json \
        ${D}${sysconfdir}/phosphor-systemd-target-monitor/
}
