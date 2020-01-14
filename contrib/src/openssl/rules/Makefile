# openssl

OPENSSL_VERSION := 1_1_1d
OPENSSL_URL := https://github.com/openssl/openssl/archive/OpenSSL_$(OPENSSL_VERSION).tar.gz

ifeq ($(call need_pkg,"OPENSSL >= 1_1_1"),)
PKGS_FOUND += openssl
endif

openssl-$(OPENSSL_VERSION).tar.gz:
	$(call download_pkg,$(OPENSSL_URL),openssl)

OPENSSL_CONF = $(HOSTCONF)

ifndef WITH_OPTIMIZATION
OPENSSL_CONF += --enable-debug
endif

.sum-openssl: openssl-$(OPENSSL_VERSION).tar.gz
	touch $@

openssl: openssl-$(OPENSSL_VERSION).tar.gz .sum-openssl
	$(UNPACK)
	mv openssl-OpenSSL_$(OPENSSL_VERSION) $@ && touch $@

OPENSSL_ARCH=$(shell $(SRC)/openssl/arch.sh $(ANDROID_ABI))
.openssl: openssl
	@echo ""
	@echo "INFO: Openssl"
	@echo ""
	$(APPLY) $(SRC)/openssl/android.patch
	cd $< && ./Configure no-shared no-unit-test -D__ANDROID_API__=$(ANDROID_API) $(OPENSSL_ARCH) --prefix=$(PREFIX)
	cd $< && $(MAKE) $(MAKE_FLAGS)
	cd $< && ../../../contrib/src/pkg-static.sh openssl.pc
	cd $< && $(MAKE) $(MAKE_FLAGS) install
	touch $@