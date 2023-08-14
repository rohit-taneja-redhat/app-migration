FROM registry.redhat.io/rhel9/nodejs-16:1-116.1690899125 as builder
WORKDIR /opt/app-root/src
ONBUILD COPY package.json ./
ONBUILD RUN npm install
ONBUILD COPY . .
ONBUILD RUN npm run build

FROM registry.access.redhat.com/ubi8/nginx-120:1-117
COPY --from=builder /usr/src/app/build /app
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
