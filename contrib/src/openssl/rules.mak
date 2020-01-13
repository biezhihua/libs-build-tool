# openssl

OPENSSL_VERSION := 1_1_1d
OPENSSL_URL := https://github.com/openssl/openssl/archive/OpenSSL_$(OPENSSL_VERSION).tar.gz
ifeq ($(call need_pkg,"OPENSSL >= 1_1_1d"),)
PKGS_FOUND += openssl
endif

$(TARBALLS)/openssl-$(OPENSSL_VERSION).tar.gz:
	$(call download_pkg,$(OPENSSL_URL),openssl)

OPENSSL_CONF = $(HOSTCONF)

ifndef WITH_OPTIMIZATION
OPENSSL_CONF += --enable-debug
endif
.sum-openssl: openssl-$(OPENSSL_VERSION).tar.gz

openssl: openssl-$(OPENSSL_VERSION).tar.gz .sum-openssl
	$(UNPACK)
	mv openssl-OpenSSL_$(OPENSSL_VERSION) $@ && touch $@

#OPENSSL_ARCH=$(shell $(SRC)/openssl/arch.sh $(ANDROID_ABI))
#export ANDROID_NDK_HOME=/some/where/android-ndk-10d
#./Configure android-arm -D__ANDROID_API__=14
.openssl: openssl
	cd $< && ./Configure no-shared -D__ANDROID_API__=$(ANDROID_API) android-arm --prefix=$(PREFIX)
	cd $< && $(MAKE)
	cd $< && ../../../contrib/src/pkg-static.sh openssl.pc
	cd $< && $(MAKE) install
	touch $@
