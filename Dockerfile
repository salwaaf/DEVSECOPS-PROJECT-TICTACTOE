# Build stage
FROM node:20-alpine AS build
# Upgrade Alpine packages
RUN apk update && apk upgrade

# Install Node.js and npm
RUN apk add --no-cache nodejs npm bash python3 make g++
RUN apk update && apk upgrade


WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]