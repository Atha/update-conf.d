## 2013-04-10
* complex version: minor fixes, shebang corrected

## 2013-04-09
* two versions renamed: SIMPLE and COMPLEX
  * run "make select-complex" or "make select-simple" to select
* COMPLEX version updated
  * set (-s) and unset (-u) logic implemented.
  * THE FUNCTIONS set and unset ARE STILL STUBS i.e. not implemented!

## 2013-04-08
* BIG version of update-conf.d added - USE WITH CAUTION! Alpha!
  * to use it, run make select-big clean install
  * BE WARNED: THIS SCRIPT HAS ALPHA STATUS! MAKE BACKUPS!

## 2013-03-28
* ebuild (by javeree) added
  * KEYWORDS changed to "*", as the script should work everywhere
* Makefile: install-with-fstab and install-update-fstab removed
  * all the text updated to reflect this change

## 2012-05-03
* update-conf.d.in and update-conf.d:
  * short help added when no command-line argument is specified
  * messages cleaned-up
  * command-line argument ? to list all valid `<conf>` entries added

## 2012-01-25
* Makefile updated: target "install" now only installs the script
* Makefile: target "install-with-fstab" added (old behaviour)
* update-conf.d.in: reference to home of the script added (GitHub)

## 2012-01-05
* README updated

## 2011-10-27
* version information (ISO date) added

## 2011-10-26
* released at GitHub
* cosmetic changes to update-fstab and update-conf.d 
  **NOTE:** update-fstab is depricated, update-conf.d should be used!
* Makefile added for easier installation

## 2011-06-11
* NicoLarve releases improved version update-conf.d for various `<conf>`.d files

## 2010-08-14
* improved version, thanks to truc

## 2010-07-25
* original version from 2008 released by Atha at the
  [Gentoo forum](http://forums.gentoo.org/viewtopic.php?p=6364143)
* the Gentoo forum advocate truc immediately helped to improve the script - big
  thanks!

## 2008-01-20
* initial version of update-fstab finished (unreleased, used by Atha)
