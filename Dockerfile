FROM nginx:1.22.1-alpine

#RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y nginx-extras apache2-utils
RUN apk update && apk add --no-cache apache2-utils
# Remove default welcome page
#RUN rm /usr/share/nginx/html/index.html

# 1. support running as arbitrary user which belogs to the root group
# 2. users are not allowed to listen on priviliged ports
# 3. comment user directive as master process is run as user in OpenShift anyhow
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
    chgrp -R root /var/cache/nginx && \
    sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf && \
    sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf && \
    addgroup nginx root

COPY webdav.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p "/data/media/webdav"
RUN chmod g+rwx /data/media/webdav

EXPOSE 8081

CMD nginx -g "daemon off;"
