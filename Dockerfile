# Multi-stage Dockerfile for a Vite + React app
# Build stage
FROM node:18-alpine AS build
WORKDIR /app

# Install dependencies (use package-lock if present)
COPY package.json package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Copy source and build
COPY . .
RUN npm run build

# Production stage - serve with nginx
FROM nginx:stable-alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: remove default nginx config if you want custom config
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]