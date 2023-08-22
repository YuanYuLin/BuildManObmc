POWER_SERVICE_PACKAGES_RASPBERRYPI = " \
                                    phosphor-power-psu-monitor \
                                    phosphor-power-utils \
                                    phosphor-power \
                                  "

RDEPENDS:${PN}-extras:append = " \
                               entity-manager \
                               ${POWER_SERVICE_PACKAGES_RASPBERRYPI} \
                               "

