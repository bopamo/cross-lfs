#!/bin/bash

### libglade ###

cd ${SRC}
LOG=libglade-gnome-platform.log

SELF=`basename ${0}`
set_buildenv
set_libdirname
setup_multiarch
if [ ! "${libdirname}" = "lib" ]; then
   extra_conf="--libdir=/usr/${libdirname}"
fi

# override TARBALLS to point at gnome/platform tree
GNOME_REL_MAJ=`echo ${GNOME_REL} | sed 's@\([0-9]*\.[0-9]*\).*@\1@g'`
export TARBALLS=${GNOME_TARBALLS}/platform/${GNOME_REL_MAJ}/${GNOME_REL}/sources

unpack_tarball libglade-${LIBGLADE_VER}
cd ${PKGDIR}

# For some reason this doesn't like python... Investigate...

max_log_init libglade ${LIBGLADE_VER} "gnome-platform (shared)" ${CONFLOGS} ${LOG}
CC="${CC-gcc} ${ARCH_CFLAGS}" \
CXX="${CXX-g++} ${ARCH_CFLAGS}" \
CFLAGS="${TGT_CFLAGS}" \
CXXFLAGS="${TGT_CFLAGS}" \
./configure --prefix=/usr --mandir=/usr/share/man \
   --infodir=/usr/share/info ${extra_conf} \
   >> ${LOGFILE} 2>&1 &&
#   --enable-gtk-doc \
echo " o Configure OK" &&

min_log_init ${BUILDLOGS} &&
make ${PMFLAGS} \
   >> ${LOGFILE} 2>&1 &&
echo " o Build OK" || barf

min_log_init ${TESTLOGS} &&
make check \
   >> ${LOGFILE} 2>&1 &&
echo " o Test OK" || errmsg

min_log_init ${INSTLOGS} &&
make install \
   >> ${LOGFILE} 2>&1 &&
echo " o ALL OK" || barf

