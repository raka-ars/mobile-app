#!/bin/bash
set -e

echo "Menjalankan smoke test untuk Flutter Web build..."
if [ ! -d "build/web" ]; then
  echo "❌ Folder build/web tidak ditemukan. Build gagal!"
  exit 1
else
  echo "✅ Build Flutter Web ditemukan. Test lulus."
fi
