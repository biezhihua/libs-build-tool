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

ifdef HAVE_ANDROID

OPENSSL_ARCH := 

ifeq ($(PLATFORM_SHORT_ARCH), arm)
	OPENSSL_ARCH =  android-arm
endif

ifeq ($(PLATFORM_SHORT_ARCH), arm64)
	OPENSSL_ARCH = android-arm64
endif

ifeq ($(PLATFORM_SHORT_ARCH), x86)
	OPENSSL_ARCH = android-x86 no-asm
endif

ifeq ($(PLATFORM_SHORT_ARCH), x86_64)
	OPENSSL_ARCH = android-x86_64
endif

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
endif

ifdef HAVE_IOS

OPENSSL_ARCH := 

ifeq ($(PLATFORM_SHORT_ARCH), armv7)
	OPENSSL_ARCH = iphoneos-cross
endif

ifeq ($(PLATFORM_SHORT_ARCH), armv7s)
	OPENSSL_ARCH = iphoneos-cross
endif

ifeq ($(PLATFORM_SHORT_ARCH), arm64)
	OPENSSL_ARCH = iphoneos-cross
endif

ifeq ($(PLATFORM_SHORT_ARCH), i386)
	OPENSSL_ARCH = darwin-i386-cc
endif

ifeq ($(PLATFORM_SHORT_ARCH), x86_64)
	OPENSSL_ARCH = darwin64-x86_64-cc
endif

.openssl: openssl
	@echo ""
	@echo "INFO: Openssl"
	@echo ""
	cd $< && ./Configure no-shared no-unit-test $(OPENSSL_ARCH) --prefix=$(PREFIX)
	cd $< && $(MAKE) $(MAKE_FLAGS)
	cd $< && ../../../contrib/src/pkg-static.sh openssl.pc
	cd $< && $(MAKE) $(MAKE_FLAGS) install
	touch $@
endif
