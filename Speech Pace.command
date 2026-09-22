#!/bin/bash
# Double-click to open Speech Pace.
# It serves this folder on http://localhost:8793 (the microphone needs a real web address,
# not a file:// one) and opens the page in Google Chrome.

cd "$(dirname "$0")" || exit 1
PORT=8793
URL="http://localhost:$PORT/"
SERVER_PID=""

if ! curl -s -o /dev/null "$URL"; then
  python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &
  SERVER_PID=$!
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    curl -s -o /dev/null "$URL" && break
    sleep 0.3
  done
fi

if ! curl -s -o /dev/null "$URL"; then
  echo ""
  echo "  Speech Pace couldn't start."
  echo "  If macOS asked whether Terminal may access your Downloads folder, choose Allow"
  echo "  (System Settings > Privacy & Security > Files and Folders > Terminal), then try again."
  echo ""
  read -n 1 -s -r -p "  Press any key to close."
  exit 1
fi

if [ -d "/Applications/Google Chrome.app" ]; then
  open -a "Google Chrome" "$URL"
else
  open "$URL"
fi

echo ""
echo "  Speech Pace is open at $URL"
if [ -n "$SERVER_PID" ]; then
  echo "  Keep this window open while you practice. Close it when you're done."
  echo ""
  wait "$SERVER_PID"
fi
