# Build stage
FROM node:20-alpine AS build

# Upgrade Alpine packages and install build tools
RUN apk update && apk upgrade && \
    apk add --no-cache bash python3 make g++

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Upgrade Alpine packages in production image too
RUN apk update && apk upgrade

COPY --from=build /app/dist /usr/share/nginx/html

# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
