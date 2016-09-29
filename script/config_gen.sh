#!/bin/bash
#
# a script to convet 'config.mk' to C header file.
#
# (C) Copyright 2016 wowotech
#
# wowo<wowo@wowotech.net>
#

CONFIG_PREFIX=XC_

# verify the parameters
if [ -z "$1" -o -z "$2" ]; then
	echo "Input error!"
	echo "Usage:"
	echo "    $0 [input_file] [output_file]"
	exit
fi

# verify the input config file
if [ ! -f $1 ]; then
	echo "can not open $1"
	exit
fi

echo "/* Auto generated configration files. DO NOT EDIT IT! */" > $2
echo "" >> $2
echo "#ifndef _XPRJ_CONFIG_H_" >> $2
echo "#define _XPRJ_CONFIG_H_" >> $2
echo "" >> $2

cat $1 | while read line
do
	# skip the comment lines
	if [ "${line:0:1}" == "#" ]; then
		continue
	fi

	# parse the configration item and value
	config_item=`echo ${line}|awk -F '=' '{print $1}'`
	config_value=`echo ${line}|awk -F '=' '{print $2}'`

	# skip the empty items
	if [ -z "${config_item}" ]; then
		continue
	fi

	#
	# check wether the config_value is number or string
	# and " " for string.
	#
	if [[ ${config_value:0:1} == [0-9] ]]; then
		echo -e "#define ${CONFIG_PREFIX}${config_item} (${config_value})" >> $2
	else
		echo -e "#define ${CONFIG_PREFIX}${config_item} \"${config_value}\"" >> $2
	fi
done

echo "" >> $2
echo "#endif /* _XPRJ_CONFIG_H_ */" >> $2
