FROM debian:stretch-slim as builder

RUN apt-get update -qy && apt-get -qy install \
        build-essential pkg-config git nasm \
        libx264-dev libssl-dev libfontconfig1-dev

WORKDIR /root
RUN git clone https://github.com/FFmpeg/FFmpeg.git --depth 1

WORKDIR /root/FFmpeg

#
# To enable h262
#   packages:  libx264-dev
#   configure: --enable-libx264
#
# To enable ssl
#   packages:  libssl-dev
#   configure: --enable-openssl
#
# To enable drawtext filter
#   packages:  libfontconfig1-dev
#   configure: --enable-libfreetype --enable-libfontconfig
#
RUN ./configure \
    --target-os=linux --enable-gpl --enable-nonfree \
    --enable-libx264 \
    --enable-openssl \
    --enable-libfreetype --enable-libfontconfig
RUN make -j$(nproc)
RUN make install

###

FROM debian:stretch-slim

RUN apt-get update \
    && apt-get -qy install \
        libx264-148 libssl1.1 libfontconfig1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root
COPY --from=builder /usr/local/bin/ /usr/local/bin
COPY --from=builder /usr/local/lib/ /usr/local/lib
COPY --from=builder /usr/local/share/ffmpeg/ /usr/local/share/ffmpeg
COPY --from=builder /usr/local/share/man/ /usr/local/share/man

CMD ["/bin/bash"]
