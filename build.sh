#!/bin/bash
# CED Africa AV Design Studio — Netlify Build Script
set -e

echo "=== CED Africa Studio — Build ==="

mkdir -p _site

# Validate required env vars
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_KEY" ]; then
  echo "WARNING: SUPABASE_URL or SUPABASE_KEY not set — app will use localStorage only"
fi
if [ -z "$RESEND_API_KEY" ]; then
  echo "WARNING: RESEND_API_KEY not set — emails will fall back to mailto:"
fi

# Inject Supabase credentials into index.html
sed "s|%%SUPABASE_URL%%|${SUPABASE_URL:-}|g; s|%%SUPABASE_KEY%%|${SUPABASE_KEY:-}|g" \
  index.html > _site/index.html

# Copy app
cp ced_studio_platform.jsx _site/ced_studio_platform.jsx

echo "=== Build complete — _site/ ready ==="
