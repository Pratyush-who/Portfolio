#!/bin/bash
set -e

# Clone Flutter if not present
if [ ! -d flutter ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# Configure Flutter for web
flutter/bin/flutter config --enable-web

# Install dependencies
flutter/bin/flutter pub get

# Create .env file with EmailJS configuration
printf 'EMAILJS_SERVICE_ID=%s\nEMAILJS_TEMPLATE_ID=%s\nEMAILJS_PUBLIC_KEY=%s\nEMAILJS_TO_EMAIL=%s\n' \
  "$EMAILJS_SERVICE_ID" \
  "$EMAILJS_TEMPLATE_ID" \
  "$EMAILJS_PUBLIC_KEY" \
  "$EMAILJS_TO_EMAIL" > .env

# Build for web
flutter/bin/flutter build web --release
