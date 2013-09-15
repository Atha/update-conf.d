PREFIX=
CONFIGDIR=$(PREFIX)/etc
INSTALLDIR=$(PREFIX)/usr/local
SBINDIR=$(INSTALLDIR)/sbin
MANDIR=$(INSTALLDIR)/share/man/man8

build:  update-conf.d.simple update-conf.d.complex

simple: update-conf.d.simple

complex: update-conf.d.complex

update-conf.d.simple:  update-conf.d.simple.in
	sed -e 's%@CONFIGDIR@%${CONFIGDIR}%' $< > $@
	-rm -f update-conf.d
	-ln -s update-conf.d.simple update-conf.d

update-conf.d.complex:  update-conf.d.complex.in
	sed -e 's%@CONFIGDIR@%${CONFIGDIR}%' $< > $@
	-rm -f update-conf.d
	-ln -s update-conf.d.complex update-conf.d

install:
	install -d "$(INSTALLDIR)" "$(CONFIGDIR)" "$(SBINDIR)" "$(MANDIR)"
	install -m 750 update-conf.d.simple "$(SBINDIR)"
	install -m 750 update-conf.d.complex "$(SBINDIR)"
	install -m 640 update-conf.d.8 "$(MANDIR)"
	install update-conf.d "$(SBINDIR)"
	-touch "$(CONFIGDIR)/update-conf.d.conf"
	-chmod 644 "$(CONFIGDIR)/update-conf.d.conf"

update:
	install -d $(INSTALLDIR) $(CONFIGDIR) $(SBINDIR) $(MANDIR)
	install -m 750 update-conf.d.simple $(SBINDIR)
	install -m 750 update-conf.d.complex $(SBINDIR)
	install -m 640 update-conf.d.8 $(MANDIR)
	install update-conf.d $(SBINDIR)

uninstall:
	-rm -f "$(SBINDIR)/update-conf.d"
	-rm -f "$(SBINDIR)/update-conf.d.simple"
	-rm -f "$(SBINDIR)/update-conf.d.complex"
	-rm -f "$(MANDIR)/update-conf.d.8"

clean:
	-rm -f update-conf.d update-conf.d.simple update-conf.d.complex *~

.PHONY: build simple complex update-conf.d.simple update-conf.d.complex install update uninstall clean
