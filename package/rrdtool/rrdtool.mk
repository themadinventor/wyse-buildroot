################################################################################
#
# rrdtool
#
################################################################################

RRDTOOL_VERSION = 1.2.30
RRDTOOL_SITE = http://oss.oetiker.ch/rrdtool/pub
RRDTOOL_LICENSE = GPLv2+ with FLOSS license exceptions as explained in COPYRIGHT
RRDTOOL_LICENSE_FILES = COPYING COPYRIGHT

RRDTOOL_DEPENDENCIES = host-pkgconf freetype libart libpng zlib
RRDTOOL_AUTORECONF = YES
RRDTOOL_INSTALL_STAGING = YES
RRDTOOL_CONF_ENV = rd_cv_ieee_works=yes rd_cv_null_realloc=nope \
			ac_cv_func_mmap_fixed_mapped=yes
RRDTOOL_CONF_OPT = --disable-perl --disable-python --disable-ruby \
			--disable-tcl --program-transform-name='' \
			$(if $(BR2_TOOLCHAIN_HAS_THREADS),,--disable-pthread)
RRDTOOL_MAKE = $(MAKE1)

define RRDTOOL_REMOVE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/rrdtool/examples
endef

RRDTOOL_POST_INSTALL_TARGET_HOOKS += RRDTOOL_REMOVE_EXAMPLES

$(eval $(autotools-package))
