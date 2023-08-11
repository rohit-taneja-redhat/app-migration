FROM registry.redhat.io/rhel9/nodejs-16-minimal:1-126 as builder
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn build

FROM registry.redhat.io/rhel9/nginx-120:1-116-source
COPY --from=builder /usr/src/app/build /app
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
