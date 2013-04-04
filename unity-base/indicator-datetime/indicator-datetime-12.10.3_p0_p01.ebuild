EAPI=4

inherit eutils flag-o-matic gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.03.26"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-datetime"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="unity-base/unity-language-pack"
DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicate-qt
	dev-libs/libtimezonemap
	gnome-base/gnome-control-center
	>=gnome-extra/evolution-data-server-3.6
	unity-base/ido"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	append-cflags -Wno-error
}

src_configure() {
	./autogen.sh --prefix=/usr \
		--with-ccpanel
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf ${ED}usr/share/locale
}