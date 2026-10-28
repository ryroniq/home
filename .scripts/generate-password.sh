#!/bin/sh

if [ "$#" -gt 2 ]; then
    echo "Usage: $0 [length] [charset]" >&2
    exit 1
fi

length="${1:-30}"
charset="${2:-A-Za-z0-9@_!#%.,;+-}"
count=10

case "$length" in
    ''|*[!0-9]*|0) echo "Error: length must be a positive integer" >&2; exit 1 ;;
esac

n=0
while [ "$n" -lt "$count" ]; do
    LC_ALL=C tr -dc -- "$charset" </dev/urandom | head -c "$length"; echo
    n=$((n + 1))
done
