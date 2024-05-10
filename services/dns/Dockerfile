FROM internetsystemsconsortium/bind9:9.18
RUN apt-get update && apt-get install -y nano
COPY bind/config/named.conf /etc/bind/named.conf
COPY bind/zones/ /etc/bind/
RUN chown -R bind:bind /etc/bind/
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
