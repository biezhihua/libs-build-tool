# FFmpeg

#Uncomment the one you want
ifeq ($(FFMPEG_CONFIG),default)
	include $(SRC)/ffmpeg/default.mak	
endif

ifeq ($(FFMPEG_CONFIG),lite)
	include $(SRC)/ffmpeg/lite.mak	
endif

ifeq ($(FFMPEG_CONFIG),min)
	include $(SRC)/ffmpeg/min.mak	
endif

ifeq ($(FFMPEG_CONFIG),mp3)
	include $(SRC)/ffmpeg/mp3.mak	
endif

ifeq ($(FFMPEG_CONFIG),mp4)
	include $(SRC)/ffmpeg/mp4.mak	
endif

FFMPEG_VERSION := 4.2.2
FFMPEG_URL := https://github.com/FFmpeg/FFmpeg/archive/n$(FFMPEG_VERSION).tar.gz

# bsf=vp9_superframe is needed to mux VP9 inside webm/mkv
FFMPEGCONF += \
	--cc="$(CC)" \
	--pkg-config="$(PKG_CONFIG)" \
	--disable-doc \
	--enable-libgsm

ifdef HAVE_DARWIN_OS
	FFMPEGCONF += \
		--disable-videotoolbox \
		--disable-securetransport
endif

DEPS_ffmpeg = zlib gsm

#
# Optional dependencies
#

# MP3 encoding via libmp3lame [no]
ifeq ($(findstring libmp3lame,$(FFMPEGCONF)),libmp3lame)
	FFMPEGCONF += --enable-libmp3lame
	DEPS_ffmpeg += lame $(DEPS_lame)
endif

# OPENSSL
ifeq ($(findstring openssl,$(FFMPEGCONF)),openssl)
	ifeq (,$(wildcard $(PREBUILT)/lib/libcrypto.a))
		FFMPEGCONF := $(subst --enable-protocol=https,--disable-protocol=https,$(FFMPEGCONF))
		FFMPEGCONF := $(subst --enable-openssl,--disable-openssl,$(FFMPEGCONF))
	else
		FFMPEGCONF += --enable-protocol=https
		FFMPEGCONF += --enable-openssl
	endif
else
	FFMPEGCONF += --disable-protocol=https
	FFMPEGCONF += --disable-openssl
endif

#
# Small size
#
WITH_OPTIMIZATION = 1
ifdef WITH_OPTIMIZATION
	# [DANGEROUS]
	# FFMPEGCONF += --enable-small
	ifeq ($(ARCH),arm)
		ifdef HAVE_ARMV7A
			FFMPEGCONF += --enable-thumb
		endif
	endif
else
	FFMPEGCONF += --optflags=-O0
endif

ifdef HAVE_CROSS_COMPILE
	FFMPEGCONF += --enable-cross-compile --disable-programs
	ifndef HAVE_DARWIN_OS
		FFMPEGCONF += --cross-prefix=$(HOST)-
	endif
endif

#
# ARM stuff
#
ifeq ($(ARCH),arm)
	FFMPEGCONF += --arch=arm

	ifdef HAVE_NEON
		FFMPEGCONF += --enable-neon
	endif

	ifdef HAVE_ARMV7A
		FFMPEGCONF += --cpu=cortex-a8
	endif

	ifdef HAVE_ARMV6
		FFMPEGCONF += --cpu=armv6 --disable-neon
	endif
endif

#
# ARM64 stuff
#
ifeq ($(ARCH),aarch64)
	FFMPEGCONF += --arch=aarch64
endif

#
# MIPS stuff
#
ifeq ($(ARCH),mipsel)
	FFMPEGCONF += --arch=mips
endif

ifeq ($(ARCH),mips64el)
	FFMPEGCONF += --arch=mips64
endif

#
# x86 stuff
#
ifeq ($(ARCH),i386)
	ifndef HAVE_DARWIN_OS
		FFMPEGCONF += --arch=x86
	endif
endif

#
# x86_64 stuff
#
ifeq ($(ARCH),x86_64)
	ifndef HAVE_DARWIN_OS
		FFMPEGCONF += --arch=x86_64
	endif
endif

#
# Darwin
#
ifdef HAVE_DARWIN_OS
	
	FFMPEGCONF += --arch=$(ARCH) --target-os=darwin
	FFMPEGCONF += --disable-lzma
	
	ifeq ($(ARCH),x86_64)
	FFMPEGCONF += --cpu=core2
	endif

	ifdef HAVE_IOS
		FFMPEGCONF += --enable-pic --extra-ldflags="$(EXTRA_CFLAGS)"

		ifdef HAVE_NEON
			FFMPEGCONF += --as="$(AS)"
		endif
	endif
endif

#
# Linux
#
ifdef HAVE_LINUX
	FFMPEGCONF += --target-os=linux --enable-pic --extra-libs="-lm"
endif

ifdef HAVE_ANDROID

	FFMPEGCONF += --target-os=android 

	# broken text relocations
	ifeq ($(ANDROID_ABI), x86)
	F	FMPEGCONF +=  --disable-mmx --disable-mmxext --disable-inline-asm
	endif

	ifeq ($(ANDROID_ABI), x86_64)
		FFMPEGCONF +=  --disable-mmx --disable-mmxext --disable-inline-asm
	endif

	ifdef HAVE_NEON
		ifeq ($(ANDROID_ABI), armeabi-v7a)
			FFMPEGCONF += --as='gas-preprocessor.pl -as-type clang -arch arm $(CC)'
		endif
	endif

endif

# Windows
ifdef HAVE_WIN32

	ifndef HAVE_VISUALSTUDIO
		
		DEPS_ffmpeg += d3d11

		ifndef HAVE_MINGW_W64
			DEPS_ffmpeg += directx
		endif

	endif

		FFMPEGCONF += --target-os=mingw32
		FFMPEGCONF += --enable-w32threads
		
	ifndef HAVE_WINSTORE
		FFMPEGCONF += --enable-dxva2
	else
		FFMPEGCONF += --disable-dxva2
	endif

	ifeq ($(ARCH),x86_64)
		FFMPEGCONF += --cpu=athlon64 --arch=x86_64
	else
		ifeq ($(ARCH),i386) # 32bits intel
			FFMPEGCONF+= --cpu=i686 --arch=x86
		else
			ifdef HAVE_ARMV7A
				FFMPEGCONF+= --arch=arm
			endif
		endif
	endif

else # !Windows
	FFMPEGCONF += --enable-pthreads

endif

# Solaris
ifdef HAVE_SOLARIS
	ifeq ($(ARCH),x86_64)
		FFMPEGCONF += --cpu=core2
	endif

	FFMPEGCONF += --target-os=sunos --enable-pic
endif

# Build
PKGS += ffmpeg

ifeq ($(call need_pkg, "FFMPEG >= 4.2.2" ),)
	PKGS_FOUND += ffmpeg
endif

FFMPEGCONF += --nm="$(NM)" --ar="$(AR)" --ranlib="$(RANLIB)" --strip="$(STRIP)" 

ffmpeg-$(FFMPEG_VERSION).tar.gz:
	$(call download_pkg,$(FFMPEG_URL),ffmpeg)

.sum-ffmpeg: ffmpeg-$(FFMPEG_VERSION).tar.gz
	touch $@

ffmpeg: ffmpeg-$(FFMPEG_VERSION).tar.gz .sum-ffmpeg
	$(UNPACK) 
	mv FFmpeg-n$(FFMPEG_VERSION) $@ && touch $@

ifdef HAVE_IOS
.ffmpeg: ffmpeg
	@echo ""
	@echo "INFO: Config $(FFMPEGCONF)"
	@echo ""
	cd $< && $(HOSTVARS_PIC) ./configure \
		--extra-ldflags="$(LDFLAGS)" $(FFMPEGCONF) \
		--prefix="$(PREFIX)" --enable-static --disable-shared
	cd $< && $(MAKE) install $(MAKE_FLAGS)
	touch $@
endif

ifdef HAVE_ANDROID
.ffmpeg: ffmpeg
	@echo ""
	@echo "INFO: Config $(FFMPEGCONF)"
	@echo ""
	cd $< && $(HOSTVARS) ./configure \
		--extra-ldflags="$(LDFLAGS)" $(FFMPEGCONF) \
		--prefix="$(PREFIX)" --enable-static --disable-shared
	cd $< && $(MAKE) install $(MAKE_FLAGS)
	touch $@
endif