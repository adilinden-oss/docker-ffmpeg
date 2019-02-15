# About

## What is this for?

I built this to stream the webcam attached to my [OctoPi](https://octoprint.org/) to online streaming services. This docker container is meant to run on a generic Linux docker host.

If you are interested in running `ffmpeg` on [Raspberry Pi](https://www.raspberrypi.org/) check out my [adilinden/rpi-ffmpeg](https://cloud.docker.com/u/adilinden/repository/docker/adilinden/rpi-ffmpeg) container and my [adilinden-oss/octoprint-webcamstreamer](https://github.com/adilinden-oss/octoprint-webcamstreamer) plugin for [OctoPi](https://octoprint.org/).

The [Dockerfile](https://github.com/adilinden-oss/docker-ffmpeg/blob/master/Dockerfile) is on GitHub [adilinden-oss/docker-ffmpeg](https://github.com/adilinden-oss/docker-ffmpeg).

## Building

Build it from Github

    git clone https://github.com/adilinden-oss/docker-ffmpeg.git
    cd docker-rpi-ffmpeg
    docker build -t adilinden/ffmpeg .

Or, get it from Docker Hub

    docker pull adilinden/ffmpeg

## Usage

To use simply execute `ffmpeg`.

    docker run -it --rm --privileged adilinden/ffmpeg ffmpeg \
        -re -f mjpeg -framerate 5 -i http://<IP of OctoPi>:8080/?action=stream \
        -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -acodec aac -ab 128k \
        -strict experimental -vcodec h264 -pix_fmt yuv420p -g 10 -vb 700k -framerate 5 \
        -f flv rtmp://a.rtmp.youtube.com/live2/<YouTube Stream ID>
