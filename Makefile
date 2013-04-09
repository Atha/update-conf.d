PREFIX=
CONFIGDIR=$(PREFIX)/etc
INSTALLDIR=$(PREFIX)/usr/local/sbin

build: update-conf.d

select-big:
	-cp update-conf.d.big update-conf.d.in

select-tiny:
	-cp update-conf.d.tiny update-conf.d.in

update-conf.d: update-conf.d.in
	sed -e 's%@CONFIGDIR@%${CONFIGDIR}%' $< > $@

install:
	install -d $(INSTALLDIR) $(CONFIGDIR)
	install -m 750 update-conf.d $(INSTALLDIR)
	-touch $(CONFIGDIR)/update-conf.d.conf
	-chmod 644 $(CONFIGDIR)/update-conf.d.conf

update:
	install -d $(INSTALLDIR)
	install -m 750 update-conf.d $(INSTALLDIR)

uninstall:
	-rm -f update-conf.d $(INSTALLDIR)
	-rm -f update-fstab $(INSTALLDIR)

clean:
	-rm -f update-conf.d update-conf.d.conf *~

.PHONY: build update-cond.d install update uninstall clean
