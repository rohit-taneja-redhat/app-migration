FROM registry.redhat.io/rhel9/nodejs-16:1-116.1690899125 as builder
WORKDIR /opt/app-root/src
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

FROM registry.redhat.io/rhel8/nginx-122:1-23

COPY ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /opt/app && chown -R nginx:nginx /opt/app && chmod -R 775 /opt/app
RUN chown -R nginx:nginx /var/cache/nginx && \
   chown -R nginx:nginx /var/log/nginx && \
   chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && \
   chown -R nginx:nginx /var/run/nginx.pid  
RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid && \
   chmod -R 775 /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid

COPY ./start-nginx.sh /usr/bin/start-nginx.sh

RUN chmod +x /usr/bin/start-nginx.sh

COPY --from=builder --chown=nginx /opt/app-root/src/build /opt/app/
RUN chmod -R a+rw /opt/app
CMD ["nginx", "-g", "daemon off;"]
