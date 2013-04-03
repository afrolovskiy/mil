#!/bin/bash

check_user() {
	if [ `whoami` != $1 ]; then
		echo "Access denied"
		exit
	fi
}

recreate_cpdir() {
	test -e $1 && rm -r $1
	test -e $1 || mkdir $1
}

find_scripts() {
	find $1 -type f -exec grep -H "^[\ ]*#\!" {} \; 2>/dev/null | sed "s/#![\ ]*/#!/g" | sed "s/\ .*$//g" > ~/temp
}

copy_scripts() {
	for line in `cat ~/temp | tr -d ' '`
	do
		file1=`echo $line | cut -d: -f1`
		name=`expr match "$file1" '.*/\(.*\)$'`
		ext=`expr match "$line" '.*/\(.*\)$'`
		file2=$1/$name.$ext
		cp $file1 $file2
	done	
}

print_count() {
	echo "Количества найденых скриптов:"
	cat ~/temp | egrep -o '#!.*$' |  sort | uniq -c > ~/temp2 #| egrep -o "\/.*"
	cat ~/temp2
}

remove_selected_scripts() {
	echo "Выберите расширение файлов для удаления или none для выходя"
	types=`cat ~/temp2 | awk -F\  '{print $2}'`
	select type in $types 'none'
	do 	
		if [ $type == 'none' ]; then
			break
		fi
		rm $1/*.$type 2>/dev/null
	done
}

dir=/usr/bin
cpdir=~/bin
check_user "student"
recreate_cpdir $cpdir
find_scripts $dir
#copy_scripts $cpdir
print_count
#remove_selected_scripts $cpdir
