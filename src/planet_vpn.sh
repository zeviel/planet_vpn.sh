#!/bin/bash

token=null
api="https://spacecom.cc"
user_agent="Android 9/realme RMX3551/5.1.2"

function login() {
	# 1 - email: (string): <email>
	# 2 - password: (string): <password>
	response=$(curl --request POST \
		--url "$api/login?email=$1&password=$(echo -n "$2" | md5sum - | awk '{print $1}')" \
		--user-agent "$user_agent" \
		--header "content-type: application/json")
	if [ -n $(jq -r ".data.token" <<< "$response") ]; then
		token=$(jq -r ".data.token" <<< "$response")
	fi
	echo $response
}

function register() {
	# 1 - email: (string): <email>
	curl --request POST \
		--url "$api/register?email=$1" \
		--user-agent "$user_agent" \
		--header "content-type: application/json"
}

function get_app_version() {
	curl --request GET \
		--url "$api/app/android/version?store=play_market" \
		--user-agent "$user_agent" \
		--header "content-type: application/json"
}

function get_own_ip() {
	curl --request GET \
		--url "$api/ip" \
		--user-agent "$user_agent" \
		--header "content-type: application/json"
}

function get_account_info() {
	curl --request GET \
		--url "$api/user" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}
