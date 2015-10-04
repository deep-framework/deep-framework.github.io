#!/usr/bin/env bash

path=$(cd $(dirname $0); pwd -P)

if [ -z $1 ]; then
  echo "Missing DEEP local path."
  exit 1
fi

deep_path=$(cd $1; pwd -P)
docs_path=${deep_path}'/docs-api'

${deep_path}'/bin/gen-api-docs.sh'
./pickup.sh ${docs_path}