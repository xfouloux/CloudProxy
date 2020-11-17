FROM ghcr.io/linuxserver/baseimage-alpine:3.12

ENV LOG_LEVEL=info
ENV LOG_HTML=
ENV PORT=8191
ENV HOST=0.0.0.0
# ENV CAPTCHA_SOLVER=harvester|<more coming soon>...
# ENV HARVESTER_ENDPOINT=https://127.0.0.1:5000/token

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	git \
	g++ \
	make \
	nodejs-npm && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	findutils \
	git \
	nodejs \
	python2 \
	chromium \
	nss \
	freetype \
	freetype-dev \
	harfbuzz \
	ca-certificates \
	ttf-freefont \
	nodejs \
	npm \
	yarn \
	sudo && \
 npm config set unsafe-perm true && \
 echo "**** install CloudProxy ****" && \
 mkdir -p /app/cloudproxy && \
 wget -o /app/cloudproxy/package.json https://raw.githubusercontent.com/xfouloux/CloudProxy/master/package.json && \
 mkdir -p /app/cloudproxy

COPY package*.json /app/cloudproxy/

WORKDIR /app/cloudproxy/

RUN echo "**** install node modules ****" && \
 PUPPETEER_PRODUCT=chrome npm install && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root \
	/tmp/* && \
 mkdir -p \
	/root

# add local files
COPY root/ /

# ports
EXPOSE 8191
