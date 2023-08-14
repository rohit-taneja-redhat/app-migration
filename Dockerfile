FROM registry.redhat.io/rhel9/nodejs-16:1-116.1690899125 as builder
WORKDIR /usr/src/app
COPY package.json ./
COPY . ./
RUN npm install react-scripts
RUN npm install & npm run build

FROM registry.redhat.io/rhel9/nginx-120:1-116-source
COPY --from=builder /usr/src/app/build /app
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
