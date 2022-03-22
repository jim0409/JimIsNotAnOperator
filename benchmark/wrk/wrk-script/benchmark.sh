#!/bin/bash

api=$1

FOLDER_PATH=${PWD}
CONNECT=10
THREAD=4
DURATION=2
REQ_URI="http://morse-test.dev-pds.svc.cluster.local:8000"

rm -rf ${FOLDER_PATH}/body.lua

function login() {
	curl --request POST \
	  --url http://morse-test.dev-pds.svc.cluster.local:8000/v1/login \
	  --header 'Content-Type: application/json' \
	  --data '{"country": "TW",
	  "phone": "886975000000",
	  "password": "password",
	  "device_id": "100000",
	  "grant_type": "password"
	}
	' | jq -r '.result.access_token'
}

function render_send_msg_lua() {
	ACCESS_TOKEN=`login`
	REQ_URL="${REQ_URI}/v1/messages"

cat << EOF > ${FOLDER_PATH}/body.lua
wrk.method = "POST"
wrk.body ='{"type": "text","group_id": "gmc2sdpq86n88l0nqfti6g","text": "somethingthatmustchangeD"}'
wrk.headers["Content-Type"] = "application/json"
wrk.headers["Authorization"] = "Bearer ${ACCESS_TOKEN}"
EOF
}

function render_login_lua() {
	REQ_URL="${REQ_URI}/v1/login"

cat << EOF > ${FOLDER_PATH}/body.lua
wrk.method="POST"
wrk.body='{"country": "TW","phone": "886975000000","password": "password","device_id": "100000","grant_type": "password"}'
wrk.headers["Content-Type"]="application/json"
EOF
}

case $api in
	"msg" )
	render_send_msg_lua
	;;
	"login" )
	render_login_lua
	;;
esac

if [[ -f "${FOLDER_PATH}/body.lua" ]]; then
	wrk -s ${FOLDER_PATH}/body.lua -c $CONNECT -t $THREAD -d $DURATION $REQ_URL
fi