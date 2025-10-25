# Gunakan image Flutter versi 3.x (Dart 3 compatible)
FROM ghcr.io/cirruslabs/flutter:3.22.0

# Set working directory di dalam container
WORKDIR /app

# Copy semua file proyek
COPY . .

# Enable web build
RUN flutter config --enable-web

# Install dependencies
RUN flutter pub get

# Build release web app
RUN flutter build web --release

# Gunakan web server bawaan untuk serve build hasilnya
EXPOSE 8080
CMD ["bash", "-c", "flutter pub global activate dhttpd && dhttpd --path build/web --port 8080"]
