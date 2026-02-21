# Build container image

FROM alpine AS cmatrixbuilder

WORKDIR /cmatrix

RUN	apk update --no-cache && \
		apk add git autoconf automake alpine-sdk ncurses-dev ncurses-static && \
		git clone https://github.com/spurin/cmatrix.git . && \
		mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts&&  \
		autoreconf -i && \
		/cmatrix/configure LDFLAGS="-static" && \
		make
		
# cmatrix Container Image

FROM alpine

LABEL	org.opencontainers.image.authors="RC" \
		org.opencontainers.image.description="Container image for https://github.com/abishekvashok/cmatrix"

RUN	apk update --no-cache && \
		apk add ncurses-terminfo-base sudo && \
		adduser -g "Thomas Anderson" -s /usr/sbin/nologin -D -H thomas && \
		adduser thomas wheel

COPY --from=cmatrixbuilder /cmatrix/cmatrix /cmatrix/cmatrix

USER	thomas
ENTRYPOINT	["/cmatrix/cmatrix"]
CMD	["-M",  "Hello World", "-k"]

# To build this image, run - 
#  docker build . -t rc03/cmatrix

# For multi architecture image, run the following commands
# 1. docker buildx create --name buildx-multi-arch
# 2. docker buildx use buildx-multi-arch
# 3. docker buildx build --no-cache --platform linux/amd64,linux/arm64/v8 . -t rc03/cmatrix --push
# 4. Run the container with the following command: docker run --rm -it rc03/cmatrix
