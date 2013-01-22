#!/bin/sh

## Basic script to compare upstream versions of packages with versions in overlay tree ##
# If run without any arguments it recurses through the overlay tree and compares versions for all packages #
# Or can be run on individual packages as 'version_check.sh <package>-<version>.ebuild'

version_check() {
	packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
	packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`

	## Overlay package names to upstream package names mapping ##
	if [ -n "`echo "${packbasename}" | grep 'appmenu-firefox'`" ]; then treepackname="${packname}"; packname="firefox-globalmenu"
	elif [ -n "`echo "${packbasename}" | grep 'appmenu-thunderbird'`" ]; then treepackname="${packname}"; packname="thunderbird-globalmenu"
	elif [ -n "`echo "${packbasename}" | grep 'fixesproto'`" ]; then treepackname="${packname}"; packname="x11proto-fixes"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-99.2'`" ]; then treepackname="${packname}"; packname="gtk+2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-99.3'`" ]; then treepackname="${packname}"; packname="gtk+3.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk-engines-unico'`" ]; then treepackname="${packname}"; packname="gtk3-engines-unico"
	elif [ -n "`echo "${packbasename}" | grep 'libXfixes'`" ]; then treepackname="${packname}"; packname="libxfixes"
	elif [ -n "`echo "${packbasename}" | grep 'lazr-restfulclient'`" ]; then treepackname="${packname}"; packname="lazr.restfulclient"
	elif [ -n "`echo "${packbasename}" | grep 'nm-applet'`" ]; then treepackname="${packname}"; packname="network-manager-applet"
	elif [ -n "`echo "${packbasename}" | grep 'unity-webapps'`" ]; then treepackname="${packname}"; packname="libunity-webapps"
	elif [ -n "`echo "${packbasename}"`" ]; then treepackname="${packname}"
	fi

	UVER=`grep UVER= ${pack} | awk -F\" '{print $2}'`
	URELEASE=`grep URELEASE= ${pack} | awk -F\" '{print $2}'`
	if [ -n "${URELEASE}" ]; then
		if [ -n "${UVER}" ]; then
			current=`echo "${packbasename}-${UVER}" | sed 's/-99./-/g'`
		else
			current=`echo "${packbasename}" | sed 's/-99./-/g'`
		fi
		upstream=`wget -q "http://packages.ubuntu.com/${URELEASE}/source/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed 's/1://g'`
		if [ -z "${upstream}" ]; then
			upstream=`wget -q "http://packages.ubuntu.com/${URELEASE}/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed 's/1://g'`
			echo
			echo "Checking http://packages.ubuntu.com/${URELEASE}/${packname}"
		else
			echo
			echo "Checking http://packages.ubuntu.com/${URELEASE}/source/${packname}"
		fi
		echo "  Current version:  ${current}"
		current_version=`echo "${current}" | sed "s/^\${treepackname}-//"`
		upstream_version=`echo "${upstream}" | sed "s/^\${packname}-//"`
		if [ "${current_version}" != "${upstream_version}" ]; then
			echo -e "  Upstream version: \033[5m\033[1m${upstream}\033[0m"
		else
			echo "  Upstream version: ${upstream}"
		fi
		echo "    Other available versions:"
		for release in {quantal-updates,raring}; do
			if [ "${release}" != "${URELEASE}" ]; then
				avail_release=`wget -q "http://packages.ubuntu.com/${release}/source/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed 's/1://g'`
				if [ -z "${avail_release}" ]; then
					avail_release=`wget -q "http://packages.ubuntu.com/${release}/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed 's/1://g'`
				fi
				if [ -n "${avail_release}" ]; then
					echo -e "      ${avail_release}  ::  ${release}"
				fi
			fi
		done
	fi
	UVER=
	upstream=
}

if [ -n "$1" ]; then
        pack="$1"
        version_check
else
	for pack in `find $(pwd) -name "*.eclass"`; do
		packbasename=`basename ${pack} | awk -F.eclass '{print $1}'`
		packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
		version_check
	done
        for pack in `find $(pwd) -name "*.ebuild"`; do
		packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
		packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
		version_check
	done
fi
