#!/bin/sh
if [ -d /opt/custom-certificates ]; then
  echo "Trusting custom certificates from /opt/custom-certificates."
  export NODE_OPTIONS="--use-openssl-ca $NODE_OPTIONS"
  export SSL_CERT_DIR=/opt/custom-certificates
  c_rehash /opt/custom-certificates
fi

# Load credentials from environment variables
if [ -f "$HOME/credentials.json" ]; then
  tmpfile=$(mktemp)
  cp "$HOME/credentials.json" "$tmpfile"
  # Find all unique {{ VAR }} patterns
  for var in $(grep -o '{{ *[A-Z0-9_]\+ *}}' "$tmpfile" | sed 's/[{} ]//g' | sort -u); do
    value=$(eval echo \$$var)
    # Escape forward slashes in value for sed
    esc_value=$(printf '%s\n' "$value" | sed 's/[\/&]/\\&/g')
    sed -i "s/{{ *$var *}}/$esc_value/g" "$tmpfile"
  done
  mv "$tmpfile" "$HOME/credentials.json"
fi

# Import credentials
n8n import:credentials --input="$HOME/credentials.json"

# Start n8n
if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec n8n "$@"
else
  # Got started without arguments
  exec n8n
fi
