#!/usr/bin/env bash

path=$(cd $(dirname $0); pwd -P)

if [ -z $1 ]; then
  echo "Missing docs path."
  exit 1
fi

cp -R $1 ${path}

libs_file=${path}/libs.json
badge_tpl_file=${path}/badge.svg.tpl
badge_file=${path}/badge.svg
put_comma=false
total_coverage=0
cov_num=0

echo -n '{' > ${libs_file}

for lib in ${path}/*; do
  if [ -d ${lib} ]; then
    lib_coverage=$(cat ${lib}/coverage.json | grep coverage | awk -F': "' '{print $2;}' | awk -F'%' '{print $1;}')

    cov_num=$(echo "$cov_num+1" | bc)
    total_coverage=$(echo "$total_coverage+$lib_coverage" | bc)

    lib_name=$(basename ${lib})

    echo 'Library '${lib_name}' found with coverage '${lib_coverage}'%'

    if [ ${put_comma} == true ]; then
      echo -n ',' >> ${libs_file}
    fi

    echo -n '"'${lib_name}'":"'${lib_name}'"' >> ${libs_file}
    put_comma=true
  fi
done

echo -n '}' >> ${libs_file}

total_coverage=$(echo "$total_coverage/$cov_num" | bc)

echo 'Total coverage '${total_coverage}'%'

badge_content=$(cat ${badge_tpl_file} | sed "s/{perc}/${total_coverage}/g")

echo ${badge_content} > ${badge_file}