FFMPEGCONF := \
	--disable-all \
	--enable-avcodec \
	--enable-avformat \
	--enable-avutil \
	--enable-swresample \
	--enable-swscale \
	--enable-avfilter \
	--enable-network \
	--enable-decoder=aac \
	--enable-decoder=h264 \
	--enable-decoder=mp3 \
	--enable-demuxer=aac \
	--enable-demuxer=h264 \
	--enable-demuxer=mp3 \
	--enable-parser=aac \
	--enable-parser=h264 \
    --enable-muxer=mp3 \
    --enable-muxer=mp4 \
    --enable-demuxer=aac \
	--enable-demuxer=concat \
	--enable-demuxer=data \
	--enable-demuxer=flv \
	--enable-demuxer=hls \
	--enable-demuxer=mov \
	--enable-demuxer=mp3 \
	--enable-demuxer=mpegps \
	--enable-demuxer=mpegts \
	--enable-demuxer=mpegvideo \
    --enable-protocol=http \
    --enable-protocol=https \
    --enable-protocol=file \
    --enable-protocol=hls \
    --enable-protocol=concat \
    --enable-openssl \
    --enable-bsf=h264_mp4toannexb \
	--disable-asm 



