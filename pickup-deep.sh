#!/usr/bin/env bash

path=$(cd $(dirname $0); pwd -P)

if [ -z $1 ]; then
  echo "Missing DEEP local path."
  exit 1
fi

deep_path=$(cd $1; pwd -P)
docs_path=${deep_path}'/docs-api'

${deep_path}'/bin/gen_api_docs.sh'
./pickup.sh ${docs_path}

function json_escape(){
  echo -n "$1" | python -c 'import json,sys; print json.dumps(sys.stdin.read())'
}


RAW_README=$(cat ${deep_path}'/README.md')
ESC_RAW_README=$(json_escape "$RAW_README")

JSON_DATA="{\"text\":$ESC_RAW_README,\"mode\":\"gfm\",\"context\":\"MitocGroup/deep\"}"
README_HTML=$(curl -XPOST --progress-bar -d "$JSON_DATA" -H "Content-Type: application/json; charset=UTF-8" "https://api.github.com/markdown")

echo "$README_HTML" > 'README.html'
