# intro
1. 工作上有時候，會需要編寫jwt的代碼。但是部署時候，通常只有linux基本指令可以操作，因為語言關係。所以限制了只能用bash來撰寫JWT
2. troubleshooting


# pre-request
1. openssl
2. jq


# 理解
JWT運作原理
- header
	1. 先把請求header放入json，順便加上`iat`生成時間 ＆ `exp`過期時間
	2. json_header 做 base64 encode

- payload
	1. json_payload 做 base64 encode

- 組合header_payload
	1. header_base64.payload_base64

- signature
	1. 將 header_payload 做 hmacsha256 簽名
	2. header_payload_sha256 做 base64 encode


# jwt_encode.sh
```sh
#!/usr/bin/env bash

#
# JWT Encoder Bash Script
#

secret='SOME SECRET'

# Static header fields.
header='{
	"typ": "JWT",
	"alg": "HS256",
	"kid": "0001",
	"iss": "Bash JWT Generator"
}'

# Use jq to set the dynamic `iat` and `exp`
# fields on the header using the current time.
# `iat` is set to now, and `exp` is now + 1 second.
header=$(
	echo "${header}" | jq --arg time_str "$(date +%s)" \
	'
	($time_str | tonumber) as $time_num
	| .iat=$time_num
	| .exp=($time_num + 1)
	'
)

echo $header

payload='{
	"Id": 1,
	"Name": "Hello, world!"
}'

base64_encode()
{
	declare input=${1:-$(</dev/stdin)}
	# Use `tr` to URL encode the output from base64.
	printf '%s' "${input}" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

json() {
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | jq -c .
}

hmacsha256_sign()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${secret}"
}

header_base64=$(echo "${header}" | json | base64_encode)
payload_base64=$(echo "${payload}" | json | base64_encode)

header_payload=$(echo "${header_base64}.${payload_base64}")
signature=$(echo "${header_payload}" | hmacsha256_sign | base64_encode)

echo "${header_payload}.${signature}"
```


# jwt_decode.sh
> 其實也可以用網站來decode: https://jwt.io/
```sh
#!/usr/bin/env bash

#
# JWT Decoder Bash Script
#

secret='SOME SECRET'

base64_encode()
{
	declare input=${1:-$(</dev/stdin)}
	# Use `tr` to URL encode the output from base64.
	printf '%s' "${input}" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

base64_decode()
{
	declare input=${1:-$(</dev/stdin)}
	# A standard base64 string should always be `n % 4 == 0`. We made the base64
	# string URL safe when we created the JWT, which meant removing the `=`
	# signs that are there for padding. Now we must add them back to get the
	# proper length.
	remainder=$((${#input} % 4));
	if [ $remainder -eq 1 ];
	then
		>2& echo "fatal error. base64 string is unexepcted length"
	elif [[ $remainder -eq 2 || $remainder -eq 3 ]];
	then
		input="${input}$(for i in `seq $((4 - $remainder))`; do printf =; done)"
	fi
	printf '%s' "${input}" | base64 --decode
}

verify_signature()
{
	declare header_and_payload=${1}
	expected=$(echo "${header_and_payload}" | hmacsha256_encode | base64_encode)
	actual=${2}

	if [ "${expected}" = "${actual}" ]
	then
		echo "Signature is valid"
	else
		echo "Signature is NOT valid"
	fi
}

hmacsha256_encode()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${secret}"
}

# Read the token from stdin
declare token=${1:-$(</dev/stdin)};

IFS='.' read -ra pieces <<< "$token"

declare header=${pieces[0]}
declare payload=${pieces[1]}
declare signature=${pieces[2]}

echo "Header"
echo "${header}" | base64_decode | jq
echo "Payload"
echo "${payload}" | base64_decode | jq

verify_signature "${header}.${payload}" "${signature}"
```


# refer:
- https://willhaley.com/blog/generate-jwt-with-bash/