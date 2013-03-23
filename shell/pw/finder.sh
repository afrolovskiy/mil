#!/bin/bash

check_user() {
	user=`whoami`
	echo $user
	if [ $user != $template ]; then
		exit
	fi
}

recreate_dir() {
	test -e $1 && rm -r $1
	test -e $1 || mkdir $1
}

get_script_interpreter() {
	str=`grep '^#!' $1`
	interpreter=`expr match "$str" '.*/\(.*\)$'`
}

get_file_type() {
	get_script_interpreter $1
	if (( `expr length "$interpreter"` == 0 )); then
		type=""
	elif [ "$available_interpreters" != "${available_interpreters/\ $interpreter\ /}" ]; then
	 	type=$interpreter
	else
		type=""
	fi
}

get_files() {
	fns=`find $1 -type f`
}

get_new_filename() {
	name=`expr match "$1" '.*/\(.*\)$'`
}

copy_scripts() {
	get_files $1
	for fn in $fns
	do
		get_file_type $fn
		if (( `expr length "$type"` != 0 )); then
			get_new_filename $fn $type
			cp $fn $2/${name}.${type}
		fi
	done
}

print_type_counts() {
	for ftype in $available_interpreters
	do
		count=`ls $1 | grep '\.'$ftype | wc -w`
		echo "type:" $ftype "  count:" $count
	done
}

remove_other_files() {
	regexp="\.\("`echo "$2" | sed -r 's/[\ ]+/\\\|/g'`"\)$"
	ls -d $1/* | grep -v $regexp | xargs rm
}

main() {
	check_user
	recreate_dir $cpdir
	copy_scripts $dir $cpdir
	print_type_counts $cpdir

	echo "Введите, пожалуйста, расширения файлов, которые необходимо оставить, через пробел"
	read available_exts

	remove_other_files $cpdir "$available_exts"
}

template="student"
dir=/bin
cpdir=~/bin
available_interpreters=" perl bash sh python erl "
main

