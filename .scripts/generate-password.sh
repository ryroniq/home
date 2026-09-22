#!/bin/bash

chars=(
	"A-Za-z0-9@_!#%.,;+-"
	"A-Za-z0-9"
)

for c in "${chars[@]}"; do
	for i in `seq 1 6`; do
		tr -dc "${c}" </dev/urandom | head -c 30; echo
	done
	echo
done
