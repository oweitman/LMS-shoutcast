#!/bin/bash

set -e

VER=$1

if [ "$VER" == "" ]; then
	echo "no version given"
	exit 1
fi

rm -fv NewShoutcast.zip

# correct version must already be included
sed -i "s#<version>.*</version>#<version>${VER}</version>#" install.xml

zip -r NewShoutcast.zip *.pm *.txt *.md *.xml HTML

CHK=$(sha1sum -b NewShoutcast.zip|awk '{print $1}')

sed -i "s#<sha>.*</sha>#<sha>${CHK}</sha>#" public.xml
sed -i "s#version=\"[0-9\.]*\" #version=\"${VER}\" #" public.xml
