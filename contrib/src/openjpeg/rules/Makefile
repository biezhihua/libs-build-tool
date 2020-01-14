# jpeg

OPENJPEG_VERSION := 2.3.1
OPENJPEG_URL := https://github.com/uclouvain/openjpeg/archive/v$(OPENJPEG_VERSION).tar.gz

$(TARBALLS)/openjpeg-v$(OPENJPEG_VERSION).tar.gz:
	$(call download_pkg,$(OPENJPEG_URL),openjpeg)

.sum-openjpeg: openjpeg-v$(OPENJPEG_VERSION).tar.gz

openjpeg: openjpeg-v$(OPENJPEG_VERSION).tar.gz .sum-openjpeg
	$(UNPACK)
	mv openjpeg-$(OPENJPEG_VERSION) openjpeg-v$(OPENJPEG_VERSION)
	$(APPLY) $(SRC)/openjpeg/fix.patch
	$(MOVE)

.openjpeg: openjpeg toolchain.cmake
	cd $< && $(HOSTVARS) $(CMAKE) \
		-DBUILD_SHARED_LIBS:bool=OFF -DBUILD_PKGCONFIG_FILES=ON \
			-DBUILD_CODEC:bool=OFF \
		.
	cd $< && $(MAKE) install
	touch $@
