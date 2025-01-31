#!/usr/bin/env bash

WEEZER_COLOUR_URL="https://colornames.org/search/results/?type=exact&query=Weezer+Blue"
USER_AGENT="WeezerColourBot (https://github.com/VinceUB/weezer-blue-checker/, 0.0.0, complaints go to vince@ultrabanana.net)"

WEEZER_COLOUR_WEBSITE=$(curl \
	-H  "User-Agent: ${USER_AGENT}" \
	-D - \
	--http1.1 \
	"${WEEZER_COLOUR_URL}" )

echo -e "${WEEZER_COLOUR_WEBSITE}\r\n"  >output.file

while [ true ]
do
	echo -e "${WEEZER_COLOUR_WEBSITE}\r\n" | \
		sed -e '/Transfer-Encoding:/d' | \
		nc -C -N -l 2326 #2326 for WZ
done &



TOKEN=$(cat token)
DISCORD_API_VERSION=10

DISCORD_WSS_URL=$(curl -H "User-Agent: ${USER_AGENT}" "https://discord.com/api/v${DISCORD_API_VERSION}/gateway" | jq -r '.["url"]')
DISCORD_WSS_HOST=$(echo ${DISCORD_WSS_URL} | sed 's/wss:\/\///')

REQUEST="GET /?v=${DISCORD_API_VERSION}&encoding=json HTTP/1.1\r
Host: ${DISCORD_WSS_HOST}\r
Upgrade: websocket\r
Sec-WebSocket-Key: aaaaaaaaaaaaaaaaaaaaaa==\r
Origin: http://${DISCORD_WSS_HOST}\r
Sec-WebSocket-Version: 13\r
Authorization: Bot ${TOKEN}\r
User-Agent: ${USER_AGENT}\r
\r\n" #Don't judge the sec-websocket-key, if it works it works

exec 3<> /tmp/weezer-blue-checker-please-don\'t-delete-me-i-don\'t-know-what-happens-if-you-do



pkill -P $$
exec 3<&-
