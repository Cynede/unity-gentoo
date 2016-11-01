# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit autotools flag-o-matic ubuntu-versionator

UURL="mirror://unity/pool/main/d/${PN}"
UVER_PREFIX="+15.10.${PVR_MICRO}"

DESCRIPTION="Run executables under a new DBus session for testing"
HOMEPAGE="https://launchpad.net/dbus-test-runner"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

RDEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.34"
DEPEND="${RDEPEND}
	dev-util/intltool
	test? ( dev-util/bustle )"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
	append-flags -Wno-error
}