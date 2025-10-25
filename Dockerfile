# Gunakan image Flutter resmi
FROM cirrusci/flutter:stable

# Set working directory
WORKDIR /app

# Copy semua file project ke dalam container
COPY . .

# Pastikan Flutter siap digunakan untuk Web
RUN flutter config --enable-web \
    && flutter pub get \
    && flutter build web --release

# Gunakan web server bawaan (gunakan Nginx untuk hosting build web)
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
