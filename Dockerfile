FROM registry.redhat.io/rhel9/nodejs-16:1-116.1690899125 as builder
WORKDIR /opt/app-root/src
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

FROM registry.redhat.io/rhel8/nginx-122:1-23
COPY --from=builder /opt/app-root/src/build/ /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
