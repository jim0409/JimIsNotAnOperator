wrk.method = "POST"
wrk.body =
	'{"first_name":"John","last_name":"Smith","age":25,"about": "I love to go rock climbing","interests":["sports","music"]}'
wrk.headers["Content-Type"] = "application/json"
