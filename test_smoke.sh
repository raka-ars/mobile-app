#!/bin/bash
if [ -f "build/web/index.html" ]; then
  echo "✅ Smoke test passed: build/web/index.html ditemukan."
  exit 0
else
  echo "❌ Smoke test gagal: file build/web/index.html tidak ditemukan."
  exit 1
fi
