POWER_SERVICE_PACKAGES_RASPBERRYPI = " \
                                    phosphor-power-psu-monitor \
                                    phosphor-power-systemd-links-monitor \
                                    phosphor-power-utils \
                                    phosphor-power \
                                  "

RDEPENDS:${PN}-extras:append = " \
                               ${POWER_SERVICE_PACKAGES_RASPBERRYPI} \
                               "

