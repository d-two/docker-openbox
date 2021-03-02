# x11docker/openbox
#
ARG BASE_IMAGE_PREFIX

FROM multiarch/qemu-user-static as qemu

FROM ${BASE_IMAGE_PREFIX}alpine

COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/

RUN apk add --no-cache openbox terminus-font

# Additional setup for x11docker option --wm=container
# Creates a custom config file /etc/x11docker/openbox-nomenu.rc
# Disable menus and minimize button.
RUN mkdir -p /etc/x11docker && \
    cp /etc/xdg/openbox/rc.xml /etc/x11docker/openbox-nomenu.rc && \
    sed -i /ShowMenu/d    /etc/x11docker/openbox-nomenu.rc && \
    sed -i s/NLIMC/NLMC/  /etc/x11docker/openbox-nomenu.rc && \
    echo "x11docker:-:1999:1999:x11docker,,,:/tmp:/bin/sh" >> /etc/passwd && \
    echo "x11docker:-:1999:" >> /etc/group

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /usr/bin/qemu-*-static

CMD openbox
