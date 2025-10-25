# Stage 1: Build Flutter web app
FROM cirrusci/flutter:stable AS build

WORKDIR /app
COPY . .

# Build Flutter web
RUN flutter config --enable-web && \
    flutter build web --release

# Stage 2: Serve via Nginx
FROM nginx:alpine

# Copy hasil build ke folder default Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
