PREFIX=
CONFIGDIR=$(PREFIX)/etc
FSTABDDIR=$(PREFIX)/etc/fstab.d
INSTALLDIR=$(PREFIX)/usr/local/sbin

build: system-fstab update-conf.d

system-fstab:
	-cp $(CONFIGDIR)/fstab 00fstab
	-echo "fstab" > update-conf.d.conf

update-conf.d: update-conf.d.in
	sed -e 's%@CONFIGDIR@%${CONFIGDIR}%' $< > $@

install-update-fstab:
	echo "Warning: update-fstab is depricated! Use \"update-conf.d fstab\" instead!"
	install -d $(INSTALLDIR) $(FSTABDDIR)
	install -m 750 update-fstab $(INSTALLDIR)
	install -m 644 00fstab $(FSTABDDIR)

install:
	install -d $(INSTALLDIR) $(CONFIGDIR)
	install -m 750 update-conf.d $(INSTALLDIR)
	install -m 644 update-conf.d.conf $(CONFIGDIR)
	install -m 644 00fstab $(FSTABDDIR)

uninstall-update-fstab:

uninstall:
	-rm -f update-conf.d $(INSTALLDIR)
	-rm -f update-fstab $(INSTALLDIR)

clean:
	-rm -f update-conf.d 00fstab update-conf.d.conf *~

.PHONY: build install uninstall clean
