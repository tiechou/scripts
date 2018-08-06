#!/bin/bash

input_file=$1
output_file=$2

cat ${input_file} | awk -F ' ' '{print $11}' > ${output_file}

