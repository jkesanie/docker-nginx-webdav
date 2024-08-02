FROM nginx:1.22.1

LABEL maintainer="jkesanie"

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y nginx-extras apache2-utils


COPY webdav.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/*


RUN mkdir -p "/media/data"

RUN chown -R www-data:www-data "/media/data"

VOLUME /media/data

CMD nginx -g "daemon off;"
