#!/usr/bin/env bash

WEEZER_COLOUR_URL="https://colornames.org/search/results/?type=exact&query=Weezer+Blue"
WEEZER_COLOUR_WEBSITE_USER_AGENT="WeezerColourBot (complaints go to vince@ultrabanana.net)"

WEEZER_COLOUR_WEBSITE=`curl \
	-H  "User-Agent: ${WEEZER_COLOUR_WEBSITE_USER_AGENT}" \
	-D - \
	--http1.1 \
	"${WEEZER_COLOUR_URL}" `

echo -e "${WEEZER_COLOUR_WEBSITE}\r\n"  >output.file

while [ true ]
do
	echo -e "${WEEZER_COLOUR_WEBSITE}\r\n" | \
		sed -e '/Transfer-Encoding:/d' | \
		nc -C -N -l 2326 #2326 for WZ
done &



pkill -P $$
