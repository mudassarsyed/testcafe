#FROM node:15-alpine3.10
FROM node:15-alpine3.13
# node image instead
# 

#RUN addgroup -g 1000 node \
#&& adduser -u 1000 -G node -s /bin/sh -D node

RUN mkdir -p /app

# # Install required dependencies (with Chromium and Firefox)
# RUN apk update && \
#     echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
#     echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
#     echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories &&  \
#     apk add --no-cache --purge -u \
#     nodejs nodejs-npm yarn \
#     chromium firefox \
#     xwininfo xvfb dbus eudev ttf-freefont fluxbox procps xvfb-run \
#     nss freetype freetype-dev harfbuzz \
#     ca-certificates wget
RUN apk add --no-cache  chromium --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main
# # Get glibc
# RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
# RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk
# RUN apk add glibc-2.29-r0.apk

# # Get glibc-bin and glibc-i18n (required by BrowserStack Local)
# RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-bin-2.29-r0.apk
# RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-i18n-2.29-r0.apk
# RUN apk --update add glibc-bin-2.29-r0.apk glibc-i18n-2.29-r0.apk
# RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

# # Required by Chromium and Firefox
RUN apk add libstdc++

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# # Copy install-deps script that installs Node.js dependecies
# # Practically `yarn install` command
# # COPY install-deps /usr/local/bin/
# # RUN chmod +x /usr/local/bin/install-deps

# # Clear cache
# RUN rm -rf /var/cache/apk/*


WORKDIR /app

# Switching to non-root user

# Required for TestCafe
EXPOSE 1337 1338


#USER node

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install


COPY . .



# Install Node.js dependecies
#ENTRYPOINT [ "npm -v" ]

#CMD xvfb-run --server-num=99 --server-args='-ac -screen 0 1024x768x16' sh linux.sh remote parallel-3   

CMD ["sh", "linux.sh", "on-prem", "parallel" ]