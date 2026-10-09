#!/usr/bin/env sh

# Setup mocks
MOCK_DIR=$(mktemp -d)
trap 'rm -rf "$MOCK_DIR"' EXIT

# Mock brightnessctl
cat << 'EOF' > "$MOCK_DIR/brightnessctl"
#!/usr/bin/env sh
if [ "$1" = "g" ]; then
    echo "$MOCK_CURR_BRIGHTNESS"
elif [ "$1" = "m" ]; then
    echo "$MOCK_MAX_BRIGHTNESS"
fi
EOF
chmod +x "$MOCK_DIR/brightnessctl"

# Mock notify-send
cat << EOF > "$MOCK_DIR/notify-send"
#!/usr/bin/env sh
echo "\$@" >> "$MOCK_DIR/notify_send_log"
EOF
chmod +x "$MOCK_DIR/notify-send"

export PATH="$MOCK_DIR:$PATH"
SCRIPT_PATH="$(dirname "$0")/brightness.sh"

fail() {
    echo "FAIL: $1"
    exit 1
}

# Test 1: Normal calculation
export MOCK_CURR_BRIGHTNESS=50
export MOCK_MAX_BRIGHTNESS=100
rm -f "$MOCK_DIR/notify_send_log"
sh "$SCRIPT_PATH"
if ! grep -q 'Brightness 50% -u low -e -h string:synchronous:brightness -h int:value:50 -i brightness' "$MOCK_DIR/notify_send_log"; then
    fail "Normal calculation failed. Log output: $(cat "$MOCK_DIR/notify_send_log")"
fi
echo "PASS: Normal calculation"

# Test 2: Zero max brightness (the edge case)
export MOCK_CURR_BRIGHTNESS=0
export MOCK_MAX_BRIGHTNESS=0
rm -f "$MOCK_DIR/notify_send_log"
sh "$SCRIPT_PATH"
if ! grep -q 'Brightness 0% -u low -e -h string:synchronous:brightness -h int:value:0 -i brightness' "$MOCK_DIR/notify_send_log"; then
    fail "Zero max brightness calculation failed. Log output: $(cat "$MOCK_DIR/notify_send_log")"
fi
echo "PASS: Zero max brightness calculation"

# Test 3: Empty max brightness
export MOCK_CURR_BRIGHTNESS=50
export MOCK_MAX_BRIGHTNESS=""
rm -f "$MOCK_DIR/notify_send_log"
sh "$SCRIPT_PATH"
if ! grep -q 'Brightness 0% -u low -e -h string:synchronous:brightness -h int:value:0 -i brightness' "$MOCK_DIR/notify_send_log"; then
    fail "Empty max brightness calculation failed. Log output: $(cat "$MOCK_DIR/notify_send_log")"
fi
echo "PASS: Empty max brightness calculation"

echo "All tests passed."
exit 0
