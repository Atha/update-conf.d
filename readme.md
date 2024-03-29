update-conf.d script for flexible /etc/``<conf>``.d configuration
=================================================================


Origin
------

In January 2008 I wrote a very simple shell script to manage fstab entries in
the way like environment variables in /etc/env.d are managed. For this I
created separated fstab files in /etc/fstab.d and wrote a shell script called
*update-fstab*.

I then released it in 2010 on the
[Gentoo Forum](http://forums.gentoo.org/viewtopic.php?p=6364143) in the hope
that it would be useful to anyone.

Since then a few people have made enhancements, and the shell script is now
even able to handle any ``<conf>``.d directory in the same way. It is now
called **update-conf.d**.

In October 2011 I created this Git repository.
If you want to contribute: every improvement, fix, patch is welcome!

2012-01-05, *Atha*

Debian 6/7 libmount
-------------------

**WARNING**

"update-conf.d fstab" is incompatible with
[Debian bug #663623](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=663623)
which adds */etc/fstab.d* support in *libmount*, part of *util-linux*. Adding
support to the mount command was discussed by certain developers on the
[LKML](https://lkml.org/lkml/2012/1/20/104), but not *yet* implemented.
On a Debian 6 "Squeeze" and 7 "Wheezy" system */etc/fstab.d* already exists and
is probably used by libmount. Hence, be very very careful when you use
update-conf.d with */etc/fstab* on a Debian 6/7 based distribution!

In Debian 8 "Jessie" (2015) this libmount behaviour was removed.

Installation
------------

There are two versions: *simple* and *complex.*

First, clean previously built versions:

    make clean

Then, to build the **complex** version:

    make complex
    make install

The **simple** version may be preferred when size and speed is a concern. It
has less options, but is much simpler, allowing easier modification to the
shell script itself, should it be needed.

To build the simple version:

    make simple
    make install

It basically does the same as the complex version, so the usage should be
almost exactly the same.

You will then have to manage */etc/update-conf.d.conf* right after the
installation, or *update-conf.d* will have no function. Read the man page for
further details.

To uninstall, run make again.

    make uninstall

This will remove */usr/local/sbin/update-conf.d*.

You can set the PREFIX variable in the *Makefile* if you want to install it
into anything other than /.

Gentoo Linux
------------

It's very easy to install update-conf.d on Gentoo Linux. The following example
assumes ``/usr/local/portage`` as your local portage directory (see Gentoo Wiki
pages [Ebuild repository](https://wiki.gentoo.org/wiki/Ebuild_repository) and
[/etc/portage/repos.conf](https://wiki.gentoo.org/wiki//etc/portage/repos.conf)
for more information):

    mkdir -p /usr/local/portage/app-admin/update-confd
    wget -O /usr/local/portage/app-admin/update-confd/update-confd-9999.ebuild https://raw.githubusercontent.com/Atha/update-conf.d/master/update-confd-9999.ebuild

The update-conf.d script will then be available for installation via portage:

    emerge -a app-admin/update-confd

Usage
-----

Please read the man page for options included in the complex version.
The following will work also for the simple version:

``<conf>`` is any configuration file you like to make *.d*'ed, i.e. split into
snippets. When reading this, simply substitute ``<conf>`` by the name of the
configuration file you want to process. *Examples:* fstab, hosts

* **Copy existing configuration**

  Copy it to a (newly created) *.d*'ed directory:

        cd /etc
        mkdir <conf>.d
        cp <conf> <conf>.d/00original

  *Example:* If your ``<conf>`` is fstab, you will now have
  /etc/fstab.d/00original

* **Add *.d*'ed directory to _/etc/update-conf.d.conf_**

        echo <conf> >> /etc/update-conf.d.conf

  You may use your favorite text editor to add/delete entries and manage
  */etc/update-conf.d.conf*.

* **Test**

  This will take all files in */etc/``<conf>``.d/* that **start with two
  digits** (^[0-9][0-9]), leave out *empty lines* and *comments ^[#]* and make
  a new */etc/``<conf>``* with  this information.

        update-conf.d <conf>

  Example:

        update-conf.d fstab

* **Configure snippets**

  Now take your existing *00original* apart and split it up into snippets that
  suit your needs. If you need examples for snippets and filenames, look at
  your */etc/env.d* directory. The original configuration file *00original* can
  then be deleted or renamed, like *A0original* or *.00original* or even
  ``<conf>``*-backup*, so it won't be included by the *update-conf.d* script.
  Now re-run *update-conf.d* ``<conf>`` to update */etc/*``<conf>``.

Concept
-------

1. **Why** would you want to split a configuration file into snippets?
   * For one, you may like a **modular configuration** basis. You can have
     individually columned configuration files that would normally only make
     your single (original) configuration file harder to read.  
     Take *fstab* for example. Lines for *proc*, *sysfs*, *tmpfs*, *swap* will
     have different column sizes than UUID based partitions or partitions
     assigned by path in */dev/disk/by-path/*, which require different columns
     than partitions assigned like */dev/sda1*. Now you can have seperate
     files for that, each with an individual ``# comment`` line for the
     columns, making each file very easy to read and edit.
   * You can use **different sources for each snippet**. For example, you could
     share a snippet over the network, to have multiple installations updated
     at the same time. All you have to do is make sure the *update-conf.d*
     script is run after syncronizing it, and you're done.
2. What other **positive effects** can I expect?
   * Your */etc/*``<conf>`` is now reproducable by running the *update-conf.d*
     script. Accidentally deleting it or altering its contents doesn't destroy
     your whole configuration.
   * You can experiment with ``<conf>`` by changing it, which will only be
     temporary until you re-run *update-conf.d*.
   * You can easily disable a snippet by renaming it to not start with two
     digets. The shell script will then ignore it and thus it will not be
     included in */etc/*``<conf>`` when you run *update-conf.d*.
   * Applications or self written scripts cannot harm your ``<conf>`` file by
     destroying it (accidentally).
3. Are there any **negative effects**?
   * Yes.
   * If you rely on applications to update your */etc/*``<conf>``, you must
     manually add this update to your */etc/*``<conf>``*.d/00something* snippet.
     Otherwise it will be lost the next time you run *update-conf.d*. Some
     Linux distributions update */etc/fstab* and */etc/hosts* (and possibly
     others) when the system configuration is changed.
   * On some systems, other utilities may already use a *.d*'ed directory in
     /etc, which makes it impossible to use update-conf.d without a PREFIX. One
     example is Debian's *libmount* (since around 2011, until 2015) which uses
     */etc/fstab.d*.
     As a sane precaution you should not create a *.d*-ed directory for this
     shell script when there already is one!

Versioning
----------

No version numbers are used, instead the date in the ISO format (2008-01-20) is
used as the version identification.

The **original script _update-fstab_ is depricated** and only included for
completeness and historical nostalgia. Don't use it.

Adaptation
----------

If you require such a shell script for a very specific task, you may want to
modify it to what is needed for this very task. For that you may find the
*simple* version of the update-conf.d script or even the *depricated
update-fstab* script more convenient, since both are certainly simpler and
easier to adapt than the *complex* version.
If you do consider modification to the *complex* version, be advised that the
main function is ``update_confd ()``.

Contribution
------------

Please, feel free to point out any error. Improvements, fixes and patched are
highly appreciated!

Copyright and license
---------------------

Copyright © 2015 Mic92 (fixes)  
Copyright © 2013 javeree  
Copyright © 2011 Nicolas Bercher  
Copyright © 2010 truc (on improvements)  
Copyright © 2008-2023 Atha

This shell script is released under the terms of the [GNU GENERAL PUBLIC LICENSE
Version 2](http://www.gnu.org/licenses/gpl-2.0-standalone.html) or (at your
option) any later version.
It is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY.
