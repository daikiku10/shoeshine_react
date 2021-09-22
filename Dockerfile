ARG NODE_TAG=12.14.1-alpine
ARG NGINX_TAG=1.18.0-alpine
ARG APP_HOME=/root/shoeshine_react

# build stage
FROM node:${NODE_TAG} as build
ARG NODE_TAG
ARG APP_HOME

# install libraries
WORKDIR ${APP_HOME}
COPY src/package*.json ./
RUN npm ci

#install code and build
COPY src/ ./
RUN npm run-script build

#deploy stage
FROM nginx:${NGINX_TAG}
ARG NGINX_TAG
ARG APP_HOME

COPY --from=build ${APP_HOME}/build/ /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]