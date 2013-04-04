# $Header$

EAPI=4
inherit git-2

DESCRIPTION="script for flexible /etc/<conf>.d configuration"
HOMEPAGE="http://forums.gentoo.org/viewtopic.php?p=6364143"
EGIT_REPO_URI="git://github.com/Atha/${PN}.d"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS="README USAGE"

src_prepare() {
        echo "patching the makefile with s:^PREFIX=:PREFIX=${D}: (required to prevent make to write outside the sandbox)"
        sed -i "s:^PREFIX=:PREFIX=${D}:" Makefile
        echo "patching the configuration to ensure it looks in /etc instead of in the sandbox"
        sed -i 's%@CONFIGDIR@%/etc%' update-conf.d.in
        echo "patching the makefile so the installation path is /usr instead of /usr/local"
        sed -i 's:^INSTALLDIR=\$(PREFIX)/usr/local/sbin:INSTALLDIR=\$(PREFIX)/usr/sbin:' Makefile
}
