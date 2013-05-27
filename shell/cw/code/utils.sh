#!/bin/bash

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
	#echo "isVisible="$isVisible
}


function checkScopeAreaSector {
	# $1, $2 - координаты объекта
	# $3, $4 - координаты положения начала отсчёта новой c/к
	# $5       - радиус зоны видимости
	# $6       - угол поворота центра сектора в полярной с.к
	# $7       - угол обзора

	# переходим к новой с/к
	xr=`echo "$1 $3" | awk "{print ($1 - $2);}"`
	yr=`echo "$2 $4" | awk "{print ($1 - $2);}"`

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

	minTeta=`echo "$6 $7" | awk "{print ($1 - $2) / 2.0;}"`
	#echo "miTeta="$minTeta
	maxTeta=`echo "$6 $7" | awk "{print ($1 + $2) / 2.0;}"`
	#echo "maxTeta="$maxTeta
	isVisible=`echo "$r $5 $teta $minTeta $maxTeta" | 
		awk '{if ($1 <= $2 && $3 >= $4 && $3 <= $5) print 1; else print 0}'`
	#echo "isVisible="$isVisible
}


testsCheckScopeArea() {

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


calculateSpeed() {
	# $1, $2 - координаты предыдущего положения цели (засечке)
	# $3       - время на предыдущей засечке
	# $4, $5 - координаты текущего положения цели
	# $6       - текущее время
	speed=`echo "sqrt(($4 - $1)*($4 - $1) + ($5 - $2)*($5 - $2)) / ($6 - $3)" | bc -l`
	#echo "speed="$speed
}

testsCalculateSpeed() {
	calculateSpeed 0 0 0 10 10 1
}

#testsCalculateSpeed


defineTargetType() {
	type=`echo "$1" | awk '{if ( $1 >=  50 && $1 < 250 ) print "plane"; else if ( $1 >= 250 && $1 < 1000 ) print "cruiser"; else if ( $1 >= 8000 && $1 < 10000 ) print "rocket"; else print "unknown";}'`
	#echo "type="$type
}


testsDefineTargetType() {
	speed=100.5
	defineTargetType $speed

	speed=400.5
	defineTargetType $speed

	speed=9000.5
	defineTargetType $speed
}

#testsDefineTargetType

