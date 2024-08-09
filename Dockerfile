FROM debian:buster-slim
# FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND noninteractive

ENV TZ=Europe/Budapest
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg --add-architecture arm64 && \
  apt-get -y update  \
  && apt-get -y install \
    build-essential \
	scons \
    sudo \
	crossbuild-essential-arm64 \
	libsdl1.2-dev:arm64 \
	libsdl-ttf2.0-dev:arm64 \
	libsdl2-dev:arm64 \
	libsdl2-image-dev:arm64 \
	libsdl2-mixer-dev:arm64 \
	libsdl2-ttf-dev:arm64 \
	libsdl2-net-dev:arm64 \
	libcurl4-openssl-dev:arm64 \
	libgles2:arm64 \
	libopenal-dev:arm64 \
	libpng-dev:arm64 \
        libfreetype6-dev:arm64 \
	nano vim git curl wget unzip cmake \
  && rm -rf /var/lib/apt/lists/*

#	and libgles-dev:arm64 someday

RUN mkdir -p /workspace; chmod +0777 /workspace; ln -s /usr/local/include /usr/include/sdkdir
WORKDIR /root

# COPY my283/include /usr/local/include/
# COPY my283/include /usr/include/
# COPY my283/lib /usr/lib/
COPY cross-compile-ldd /usr/bin/aarch64-linux-gnu-ldd
COPY freetype-config /usr/bin/freetype-config
COPY setup-env.sh .
RUN cat setup-env.sh >> .bashrc

VOLUME /workspace
WORKDIR /workspace

ENV CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
ENV PREFIX=/usr
ENV PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig/:/usr/local/lib/pkgconfig/
ENV CC="aarch64-linux-gnu-gcc"
ENV CXX="aarch64-linux-gnu-g++"

CMD ["/bin/bash"]
