#!/bin/bash


echo "РЛС $1"

DirectoryTargets="/tmp/GenTargets/Targets"

DirectoryFindedTargets="/tmp/RLS$1/Finded"
rm -rf $DirectoryFindedTargets >/dev/null 2>/dev/null
mkdir $DirectoryFindedTargets >/dev/null 2>/dev/null

DirectoryDiscoveredTargets="/tmp/RLS$1/Discovered"
rm -rf $DirectoryDiscoveredTargets >/dev/null 2>/dev/null
mkdir $DirectoryDiscoveredTargets >/dev/null 2>/dev/null


Timeout=$2
objectX=$3
objectY=$4
objectR=$5
objectTeta=$6
objectAngle=$7



checkScopeAreaCircle() {
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


checkScopeAreaSector() {
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
	pi=`echo | awk "{print (4 * atan2(1,1));}"`
	teta=`echo "$xr $yr $pi" | awk "{
		if ($1 == 0 && $2 > 0) 
			print ($3/2.0); 
		else if ($1 == 0 && $2 < 0) 
			print (3*$3/2.0); 
		else if ($1 == 0 && $2 == 0) 
			print 0;
		else if ($1 > 0 && $2 >= 0)
			print (atan2($2, $1));
		else if ($1 > 0 && $2 < 0)
			print (atan2($2, $1) + 2*$3);
		else 
			print (atan2($2, $1) + $3);}"`
	teta=`echo "180*$teta/$pi" | bc -l`

	minTeta=`echo "$6 $7" | awk "{print ($1 - $2) / 2.0;}"`
	maxTeta=`echo "$6 $7" | awk "{print ($1 + $2) / 2.0;}"`
	isVisible=`echo "$r $5 $teta $minTeta $maxTeta" | 
		awk '{if ($1 <= $2 && $3 >= $4 && $3 <= $5) print 1; else print 0}'`
}


calculateSpeed() {
	# $1, $2 - координаты предыдущего положения цели (засечке)
	# $3       - время на предыдущей засечке
	# $4, $5 - координаты текущего положения цели
	# $6       - текущее время
	speed=`echo "sqrt(($4 - $1)*($4 - $1) + ($5 - $2)*($5 - $2)) / ($6 - $3)" | bc -l`
}


defineTargetType() {
	type=`echo "$1" | awk '{if ( $1 >=  50 && $1 < 250 ) print "plane"; else if ( $1 >= 250 && $1 < 1000 ) print "cruiser"; else if ( $1 >= 8000 && $1 < 10000 ) print "rocket"; else print "unknown";}'`
}


detectTargets() {
	for target in `ls -t "$DirectoryTargets" | head -n 100 | cut -d \. -f 3`
	do
		lastFilename=`ls -t "$DirectoryTargets" | grep "Target.id.$target" | head -n 1`
		if [ -f "$DirectoryFindedTargets/Target.id.$target" ];
		then
			if [ ! -f "$DirectoryDiscoveredTargets/Target.id.$target" ];
			then
				x2=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 1`
				y2=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 2`

				checkScopeAreaSector $x2  $y2 $objectX $objectY $objectR $objectTeta $objectAngle
				if [ "$isVisible" -eq 1 ]; then
					x1=`cat "$DirectoryFindedTargets/Target.id.$target" | cut -d \  -f 1`
					y1=`cat "$DirectoryFindedTargets/Target.id.$target" | cut -d \  -f 2`
					echo "Обнаружена цель ID:$target с координатами $x2 $y2"
					calculateSpeed $x1 $y1 0 $x2 $y2 $Timeout
					defineTargetType $speed
					if [ "$type" == "rocket" ]; then
						# Проверка направления к СПРО
						echo "Цель ID:$target движется в направлении СПРО"
					fi	
					cp "$DirectoryFindedTargets/$lastFilename" "$DirectoryDiscoveredTargets/Target.id.$target"			
				fi
			fi
		else
			x1=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 1`
			y1=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 2`
			checkScopeAreaSector $x1  $y1 $objectX $objectY $objectR $objectTeta $objectAngle
			if [ "$isVisible" -eq  1 ]; then
				cp "$DirectoryTargets/$lastFilename" "$DirectoryFindedTargets/Target.id.$target"
			fi
		fi		
	done
}

while :  # бесконечный цикл
do
    detectTargets
done
