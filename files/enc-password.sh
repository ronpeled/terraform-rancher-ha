#!/bin/bash
set -e

CLEARTEXT=$1

if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo
    echo Usage: $0 password
    echo
    echo Example: $0 supersecretpass
    echo
    exit 1
fi

KEYBASE64=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64)
KEYHEX=$(echo -n "$KEYBASE64" | base64 --decode | xxd -p -u -cols 256)
IV=$(dd if=/dev/urandom bs=16 count=1 2>/dev/null | xxd -p -u -cols 256)

echo PASSWORD: ${IV}:$(echo -n "$CLEARTEXT" | openssl enc -aes-256-cbc -nosalt -K $KEYHEX -iv $IV | xxd -p -u -cols 256)
echo KEY: $KEYBASE64
