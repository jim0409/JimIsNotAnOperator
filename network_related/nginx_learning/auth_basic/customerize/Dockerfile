FROM nginx:1.11.9-alpine

# for htpasswd command
RUN apk add --no-cache --update \
      apache2-utils
RUN rm -f /etc/nginx/conf.d/*

# use SIGQUIT for graceful shutdown
# c.f. http://nginx.org/en/docs/control.html
STOPSIGNAL SIGQUIT
# docker build --build-arg USR=jim .. to replace origin USR
ARG USR=root
# docker build --build-arg SEC=secret .. to replace origin SEC
ARG SEC=password

RUN htpasswd -bBc /etc/nginx/.htpasswd $USR $SEC
COPY nginx.conf /etc/nginx/nginx.conf
