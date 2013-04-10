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
	rm ~/temp1 2>/dev/null
	rm ~/temp2 2>/dev/null
}

find_scripts() {
	for file in `find $1 -type f`
	do
		interpreter=`head -n 1 $file 2>/dev/null | egrep '^\ *#!' | sed 's/\ *#/#/g' | sed 's/#!\ *//g' | sed 's/\ .*$//g' | sed 's/.*\///g'`
		if (( ${#interpreter} > 0 )); then
			echo $interpreter >> ~/temp1
			name=`expr match "$file" '.*/\(.*\)$'`
			file2=$2/$name.$interpreter
			cp $file $file2
		fi
	done
}

print_count() {
	echo "Количества найденых скриптов:"
	cat ~/temp1 | sort | uniq -c > ~/temp2
	cat ~/temp2
}

remove_selected_scripts() {
	echo "Выберите расширение файлов для удаления или none для выходя"
	#types=`cat ~/temp3 | awk -F\ '{print $2}'`
	types=`cat ~/temp1 | sort | uniq`
	select type in $types 'none'
	do 	
		if [ $type == 'none' ]; then
			break
		fi
		rm $1/*.$type 2>/dev/null
	done
}

dir=/bin
cpdir=~/bin
check_user "student"
recreate_cpdir $cpdir
find_scripts $dir $cpdir
print_count
remove_selected_scripts $cpdir
