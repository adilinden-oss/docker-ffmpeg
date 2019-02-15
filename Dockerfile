FROM debian:jessie-slim as builder

RUN apt-get update -qy && apt-get -qy install \
        build-essential pkg-config git nasm \
        libx264-dev libssl-dev

WORKDIR /root
RUN git clone https://github.com/FFmpeg/FFmpeg.git --depth 1

WORKDIR /root/FFmpeg
RUN ./configure --target-os=linux --enable-gpl --enable-nonfree --enable-libx264 --enable-openssl
RUN make -j$(nproc)
RUN make install

###

FROM debian:jessie-slim

RUN apt-get update \
    && apt-get -qy install \
        libx264-142 libssl1.0.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root
COPY --from=builder /usr/local/bin/ /usr/local/bin
COPY --from=builder /usr/local/lib/ /usr/local/lib
COPY --from=builder /usr/local/share/ffmpeg/ /usr/local/share/ffmpeg
COPY --from=builder /usr/local/share/man/ /usr/local/share/man

CMD ["/bin/bash"]
