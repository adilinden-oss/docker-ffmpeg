FROM balenalib/raspberry-pi-debian:stretch as builder

RUN apt-get update -qy && apt-get -qy install \
        build-essential git nasm \
        libomxil-bellagio-dev

WORKDIR /root
RUN git clone https://github.com/FFmpeg/FFmpeg.git --depth 1

WORKDIR /root/FFmpeg
RUN ./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree
RUN make -j$(nproc)
RUN make install

###

FROM balenalib/raspberry-pi-debian:stretch

WORKDIR /root
COPY --from=builder /usr/local/bin/ /usr/local/bin
COPY --from=builder /usr/local/lib/ /usr/local/lib
COPY --from=builder /usr/local/share/ffmpeg/ /usr/local/share/ffmpeg
COPY --from=builder /usr/local/share/man/ /usr/local/share/man

CMD ["/bin/bash"]
