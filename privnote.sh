#!/bin/sh

message=""
i=1
j=$#
while [ $i -le $j ]
do
	message="$message $1"
	i=$((i + 1))
	shift 1
done

password=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c9)
data=$(echo "$message" | openssl enc -e -aes-256-cbc -k $password -a -md md5 2> /dev/null)
 
note_link=$(curl -s 'https://privnote.com/' \
    -H 'X-Requested-With: XMLHttpRequest' \
    --data-urlencode "data=$data" \
    --data "has_manual_pass=false&duration_hours=0&dont_ask=false&data_type=T&notify_email=&notify_ref=" \
    | jq -r --arg arg $password '.note_link + "#" + $arg')

echo "$note_link"
(echo "$note_link" | xclip -selection c) 2> /dev/null
