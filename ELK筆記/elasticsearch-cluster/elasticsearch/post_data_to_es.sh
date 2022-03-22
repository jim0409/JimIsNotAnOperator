#!/bin/bash

function create_index(){
	local index=$1
	# create index
	curl -XPUT http://localhost:9200/$index
}


function insert_record() {
	local index=$1
	local type=$2
	# create records with context ...
	curl -XPOST -H "Content-Type: application/json" http://localhost:9200/$index/$type -d '{
		"first_name" : "John",
		"last_name" : "Smith",
		"age" : 25,
		"about" : "I love to go rock climbing",
		"interests": [ "sports", "music" ]
	}'
}

create_index hello
insert_record hello employee