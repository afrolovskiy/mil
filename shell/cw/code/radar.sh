#!/bin/bash

#RLSDirectory=/tmp/RLS$1
#FindedTargetsFile=$RLSDirectory/targets.txt

#Timeout=0.5
#DirectoryTargets="$TempDirectory/Targets"

# получение идентификатора
#echo $Filename | cut -d \. -f 3

#ls $DirectoryTargets | cut -d \. -f 3 | sort | uniq # idшники целей

#grep -Fxvf file2 file1 # сравнение 2-х файлов: найдет е записис, которых нет в file2

#TargetFile=/tmp/GenTargets/Targets/Target.id.42def7.d3e390f909790423aec89c2734f36d78
#x=`cat $TargetFile | cut -d \  -f 1`
#echo "x="$x
#y=`cat $TargetFile | cut -d \  -f 2`
#echo "y="$y


#ls -t $DirectoryTarget | grep Target.id.0cacf6 | head -n 1 # последний файл с таким id iником

#xc=9500
#echo "xc="$xc
#yc=3000
#echo "yc="$yc

# Расчет попадания в зону видимости
#xr=$(($x - $xc))
#echo "xr="$xr
#yr=$(($y-$yc))
#echo "yr="$yr
#r=`echo "sqrt($xr*$xr + $yr*$yr)" | bc -l`
#echo $r

function checkScopeAreaCircle {
	# $1, $2 - координаты объекта
	# $3, $4 - координаты положения начала отсчёта новой c/к
	# $5       - радиус зоны видимости

	# переходим к новой с/к
	xr=$(($1 - $3))
	yr=$(($2 - $4))

	# переходим к полярной с/к
	r=`echo "sqrt($xr*$xr + $yr*$yr)" | bc -l`
	#echo "r="$r
	
	isVisible=`echo "$r $5" | awk '{if ($1 <= $2) print 1; else print 0}'`
	echo "isVisible="$isVisible
}


function checkScopeAreaSector {
	# $1, $2 - координаты объекта
	# $3, $4 - координаты положения начала отсчёта новой c/к
	# $5       - радиус зоны видимости
	# $6       - угол поворота центра сектора в полярной с.к
	# $7       - угол обзора

	# переходим к новой с/к
	xr=$(($1 - $3))
	yr=$(($2 - $4))

	# переходим к полярной с/к
	r=`echo "sqrt($xr*$xr + $yr*$yr)" | bc -l`
	#echo "r="$r

	pi=`echo "4*a(1)" | bc -l`
	if (($xr == 0 && $yr > 0)); then
		teta=$(($pi/2))
	elif (($xr == 0 && $yr < 0)); then
		teta=$((3*$pi/2))
	elif (($xr == 0 && $yr == 0)); then
		teta=0
	elif (($xr > 0 && $yr >= 0)); then
		teta=`echo "a($yr/$xr)" | bc -l` 
	elif (($xr > 0 && $yr < 0)); then
		teta=`echo "a($yr/$xr) + 2*$pi" | bc -l` 
	else
		teta=`echo "a($yr/$xr) + $pi" | bc -l` 
	fi
	teta=`echo "180*$teta/$pi" | bc -l`
	#echo "teta="$teta

	minTeta=$(($6 - $7/2))
	#echo "miTeta="$minTeta
	maxTeta=$(($6 + $7/2))
	#echo "maxTeta="$maxTeta
	isVisible=`echo "$r $5 $teta $minTeta $maxTeta" | 
		awk '{if ($1 <= $2 && $3 >= $4 && $3 <= $5) print 1; else print 0}'`
	echo "isVisible="$isVisible
}


tests() {

	echo "tests for circle"

	echo "visible"
	x=5
	y=5
	xc=3
	yc=3
	R=3
	checkScopeAreaCircle $x $y $xc $yc $R

	echo "visible"
	x=12
	y=12
	xc=10
	yc=10
	R=3
	checkScopeAreaCircle $x $y $xc $yc $R

	echo "nonvisible"
	x=5
	y=5
	xc=10
	yc=10
	R=3
	checkScopeAreaCircle $x $y $xc $yc $R

	echo "tests for sector"

	echo "visible"
	x=1
	y=2
	xc=3
	yc=3
	R=3
	a=225
	b=90
	checkScopeAreaSector $x $y $xc $yc $R $a $b

	echo "nonvisible"
	x=1
	y=5
	xc=3
	yc=3
	R=3
	a=225
	b=90
	checkScopeAreaSector $x $y $xc $yc $R $a $b

	echo "nonvisible"
	x=5
	y=5
	xc=3
	yc=3
	R=3
	a=225
	b=90
	checkScopeAreaSector $x $y $xc $yc $R $a $b
}

tests




#while :  # бесконечный цикл
#do
    



    #sleep $Timeout
#done
