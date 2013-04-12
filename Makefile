PREFIX=
CONFIGDIR=$(PREFIX)/etc
INSTALLDIR=$(PREFIX)/usr/local/sbin

build: update-conf.d

select-complex:
	-cp update-conf.d.complex update-conf.d.in

select-simple:
	-cp update-conf.d.simple update-conf.d.in

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

.PHONY: build update-conf.d install update uninstall clean
