#!/usr/bin/env bash

path=$(cd $(dirname $0); pwd -P)

if [ -z $1 ]; then
  echo "Missing docs path."
  exit 1
fi

cp -R $1 ${path}
