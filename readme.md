update-conf.d script for flexible /etc/``<conf>``.d configuration
=================================================================


Origin
------

In January 2008 I wrote a very simple script to manage fstab entries in the way
like environment variables in /etc/env.d are managed. For this I created
separated fstab files in /etc/fstab.d and wrote a script called *update-fstab*.

I then released it in 2010 on the
[Gentoo Forum](http://forums.gentoo.org/viewtopic.php?p=6364143) in the hope
that it would be useful to anyone.

Since then a few people have made enhancements, and the script is now even able
to handle any ``<conf>``.d directory in the same way. It is now called
**update-conf.d**.

In October 2011 I created this GIT repository.
If you want to contribute: every improvement, fix, patch is welcome!

2012-01-05, *Atha*

Installation
------------

There are two versions: *simple* and *complex.*

First, clean previously built versions:

    > make clean

Then, to build the **complex** version:

    > make complex
    > make install

The **simple** version may be preferred when size and speed is a concern. It
has less options, but is much simpler, allowing easier modification to the
script itself, should it be needed.

To build the simple version:

    > make simple
    > make install

It basically does the same as the complex version, so the usage should be
almost exactly the same.

You will then have to manage */etc/update-conf.d.conf* right after the
installation, or *update-conf.d* will have no function. Read the man page for
further details.

To uninstall, run make again.

    > make uninstall

This will remove */usr/local/sbin/update-conf.d* and
*/usr/local/sbin/update-fstab*.

You can set the PREFIX variable in the *Makefile* if you want to install it
into anything other than /.


Usage
-----

Please read the man page for options included in the complex version.
The following will work also for the simple version:

``<conf>`` is any configuration file you like to make *.d*'ed, i.e. split into
snippets. When reading this, simply substitute ``<conf>`` by the name of the
configuration file you want to process. *Examples:* fstab, hosts

* **Copy existing configuration**

  Copy it to a (newly created) *.d*'ed directory:

        > cd /etc
        > mkdir <conf>.d
        > cp <conf> <conf>.d/00original

  *Example:* If your ``<conf>`` is fstab, you will now have
  /etc/fstab.d/00original

* **Add *.d*'ed directory to _/etc/update-conf.d.conf_**

        > echo <conf> >> /etc/update-conf.d.conf

  You may use your favorite text editor to add/delete entries and manage
  */etc/update-conf.d.conf*.

* **Test**

  This will take all files in */etc/``<conf>``.d/* that **start with two
  digits** (^[0-9][0-9]), leave out *empty lines* and *comments ^[#]* and make
  a new */etc/``<conf>``* with  this information.

        > update-conf.d <conf>

  Example:

        > update-conf.d fstab

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
     digets. The script will then ignore it and thus it will not be included in
     */etc/*``<conf>`` when you run *update-conf.d*.
   * Applications or self written scripts cannot harm your ``<conf>`` file by
     destroying it (accidentally).
3. Are there any **negative effects**?
   * Yes.
   * If you rely on applications to update your */etc/*``<conf>``, you must
     manually add this update to your */etc/*``<conf>``*.d/00something* snippet.
     Otherwise it will be lost the next time you run *update-conf.d*. Some
     Linux distributions update */etc/fstab* and */etc/hosts* (and possibly
     others) when the system configuration is changed.

Versioning
----------

No version numbers are used, instead the date in the ISO format (2008-01-20) is
used as the version identification.

The **original script _update-fstab_ is depricated** and only included for
completeness and historical nostalgia. Don't use it.

Contribution
------------

Please, feel free to point out any error. Improvements, fixes and patched are
highly appreciated!

Copyright and license
---------------------

Copyright © 2013 javeree  
Copyright © 2011 Nicolas Bercher  
Copyright © 2010 truc (on improvements)  
Copyright © 2008-2013 Atha

This script is released under the terms of the [GNU GENERAL PUBLIC LICENSE
Version 2](http://www.gnu.org/licenses/gpl-2.0-standalone.html) or (at your
option) any later version.
It is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY.
