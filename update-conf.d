#!/bin/sh
#
# Version 2012-05-03
#
# Script for flexible /etc/*.d configuration
# Originally from Atha, with a lot of improvements from truc - thanks!
# Generalized for /etc/*.d by Nicolas Bercher nbercher@yahoo.fr
#
# The included makefile assists easy installation: "make build ; make install"
#
# This script ideally goes into /usr/local/sbin and is called update-conf.d -
# you need to configure your <conf> entries in separate files in /etc/<conf>.d;
# only filenames starting with two digits are included!
#
# Examples: /etc/fstab.d/01base or /etc/hosts.d/61nfs-dm8000, to name just two.
#
# Copyright 2011 Nicolas Bercher
# Copyright 2010 truc (on improvements)
# Copyright 2008,2010 Atha
# Distributed under the terms of the GNU General Public License v2 or later
#
# The home of this script is https://github.com/Atha/update-conf.d
# It first appeared at http://forums.gentoo.org/viewtopic.php?p=6364143
#


## SETUP
# scriptname:
scriptname=$(basename "$0")
# root of configuration files:
root="/etc"
# script configuration path:
scriptconf="${root}/update-conf.d.conf"
# name of the configuration file to process:
conf="${1}"
# configuration file path:
confpath="${root}/${conf}"
# path to the backup of the current/previous configuration file:
bkpconfpath="${confpath}.d.bak"
# <conf.d> directory path:
dpath="${root}/${conf}.d"
# path to the intermediate location of the new configuration file based on
# <conf>.d/[0-9][0-9]* files:
dconfpath="${dpath}/$(basename ${conf})"
# flag_verbose sets the verbosity level.
# Default is 1 (verbose output). If you want no messages set this to 0.
flag_verbose="1"


## FUNCTIONS
message () {
  [ ${flag_verbose} -gt 0 ] && echo $@
}


## MAIN PROGRAM
if [ ! -f "${scriptconf}" ]; then
  echo "${scriptname}: Script configuration file '${scriptconf}' not found!" >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "${scriptname}: <conf> entry must be specified as a command-line argument.
${scriptname}: type \"${scriptname} ?\" for a list of valid <conf> entries." >&2
  exit 1
fi

if [ "${conf}" = "?" ]; then
  echo "Usage: ${scriptname} <conf>

List of valid <conf> entries:"
  cat ${scriptconf}
  echo "
Edit ${scriptconf} to add or delete entries."
  exit 0
fi

if ! grep "^${conf}$" "${scriptconf}"; then
  echo "${scriptname}: Not allowed to process file ${confpath}, see ${scriptconf}." >&2
  exit 1
fi

if [ ! -d "${dpath}" ] ; then
  echo "${scriptname}: ${dpath} is not present!" >&2
  exit 1
fi

if [ -e "${dconfpath}" ] ; then
  echo "${scriptname}: please remove ${dconfpath} before you run this script.
${scriptname}: NOTE: It may have been left by a previous run, but you should check anyway." >&2
  exit 2
fi

cat << 'EOT' > "${dconfpath}" && message "${dconfpath} created, header added"
# Configuration file automatically generated by the update-conf.d
# script.
#
# Please change the according lines in /etc/<conf.d>/* if you want
# them to be permanent, otherwise they will not survive the next
# invocation of update-conf.d!
#
EOT

for dconf_file in "${dpath}"/[0-9][0-9]* ; do
  echo "" >> "${dconfpath}"
  echo "# ${dconf_file}:" >> "${dconfpath}"
  grep '^[^#].*' "${dconf_file}" >> "${dconfpath}"
  message "Added: ${dconf_file}"
done

mv -f "${confpath}" "${bkpconfpath}" && message "Existing ${confpath} renamed to ${bkpconfpath}"
mv -f "${dconfpath}" "${confpath}" && message "New configuration file ${dconfpath} moved to ${confpath}"

echo "${scriptname}: ${confpath} updated."
exit 0
