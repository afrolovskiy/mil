#!/bin/bash

source $(dirname $0)/utils.sh

DirectoryTargets="/tmp/GenTargets/Targets"

DirectoryFindedTargets="/tmp/RLS$1"
mkdir $DirectoryFindedTargets >/dev/null 2>/dev/null

Timeout=$2
objectX=$3
objectY=$4
objectR=$5
objectTeta=$6
objectAngle=$7



#tests

detectTargets() {
	for target in `ls -t "$DirectoryTargets" | head -n 100 | cut -d \. -f 3 | sort | uniq`
	do
		lastFilename=`ls -t "$DirectoryTargets" | grep "Target.id.$target" | head -n 1`
		
		if [ -f "$DirectoryFindedTargets/Target.id.$target" ];
		then
			x2=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 1`
			y2=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 2`

			checkScopeAreaSector $x2  $y2 $objectX $objectY $objectR $objectTeta $objectAngle
			if (($isVisible == 1)); then
				echo "alredy finded"
				x1=`cat "$DirectoryFindedTargets/Target.id.$target" | cut -d \  -f 1`
				y1=`cat "$DirectoryFindedTargets/Target.id.$target" | cut -d \  -f 2`
				echo "Обнаружена цель ID:$target с координатами $x2 $y2"
				calculateSpeed $x1 $y1 0 $x2 $y2 $Timeout
				defineTargetType $speed
				if [ $type == $rocket ]; then
					# Проверка направления к СПРО
					echo "Цель ID:$target движется в направлении СПРО"
				fi				
			fi
		else
			x1=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 1`
			y1=`cat "$DirectoryTargets/$lastFilename" | cut -d \  -f 2`
			checkScopeAreaSector $x1  $y1 $objectX $objectY $objectR $objectTeta $objectAngle
			if (($isVisible == 1)); then			
				cp "$DirectoryTargets/$lastFilename" "$DirectoryFindedTargets/Target.id.$target"
			fi
		fi		
	done
}

while :  # бесконечный цикл
do
    detectTargets



    #sleep $Timeout
done
