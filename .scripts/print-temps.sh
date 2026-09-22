#!/bin/sh

sensors $SENSORS_CHIPS \
| sed -e '/Adapter:/d' -e 's/(.*)//g' -e '/^  *$/d' -e 's/ *$//g' -e 's/  */ /g' -e 's/ *$//g' \
| awk -F : '{
	if ($0 ~ /^ *$/) {
		print ""
	} else if ($0 ~ /.+:./) {
		printf("%10s:%10s\n", $1, $2)
	} else {
		print "[" $0 "]"
	}
}'
