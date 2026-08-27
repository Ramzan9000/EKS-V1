FROM nginx:1.27-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY App/ /usr/share/nginx/html/

COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i 's|pid[[:space:]]*/run/nginx.pid;|pid /tmp/nginx.pid;|' /etc/nginx/nginx.conf \
    && chown -R nginx:nginx /var/cache/nginx

EXPOSE 8080

USER nginx

CMD ["nginx", "-g", "daemon off;"]