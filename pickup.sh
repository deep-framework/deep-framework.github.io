#!/usr/bin/env bash

path=$(cd $(dirname $0); pwd -P)

if [ -z $1 ]; then
  echo "Missing docs path."
  exit 1
fi

cp -R $1 ${path}

libs_file=${path}/libs.json
put_comma=false

echo -n '{' > ${libs_file}

for lib in ${path}/*; do
  if [ -d ${lib} ]; then
    lib_name=$(basename ${lib})

    if [ ${put_comma} == true ]; then
      echo -n ',' >> ${libs_file}
    fi

    echo -n '"'${lib_name}'":"'${lib_name}'"' >> ${libs_file}
    put_comma=true
  fi
done

echo -n '}' >> ${libs_file}
