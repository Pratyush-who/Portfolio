#!/bin/bash
set -e

git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$HOME/flutter/bin:$PATH"

flutter --version
flutter config --enable-web

cat > .env <<EOF
EMAILJS_SERVICE_ID=$EMAILJS_SERVICE_ID
EMAILJS_TEMPLATE_ID=$EMAILJS_TEMPLATE_ID
EMAILJS_PUBLIC_KEY=$EMAILJS_PUBLIC_KEY
EOF

flutter pub get
flutter build web --release --no-source-maps --tree-shake-icons