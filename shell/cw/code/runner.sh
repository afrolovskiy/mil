#!/bin/bash



# РЛС 1 Дунай-ЗУ Хабаровск 
Timeout=1.0
objectX=9500000
objectY=3000000
objectR=4500000
objectTeta=315
objectAngle=48
source radar.sh 1 $Timeout $objectX $objectY $objectR $objectTeta $objectAngle &


# РЛС 2 Днепр 
Timeout=1.0
objectX=9000000
objectY=6000000
objectR=3000000
objectTeta=225
objectAngle=120
source radar.sh 2 $Timeout $objectX $objectY $objectR $objectTeta $objectAngle &


# РЛС 3 Дарьял Новосибирск
Timeout=1.0
objectX=6100000
objectY=3700000
objectR=6000000
objectTeta=270
objectAngle=90
source radar.sh 3 $Timeout $objectX $objectY $objectR $objectTeta $objectAngle &


# ЗРДН 1 Барнаул
Timeout=1.0
objectX=6100000
objectY=3500000
objectR=600000


# ЗРДН 2 Уфа
Timeout=1.0
objectX=4200000
objectY=3700000
objectR=400000


# ЗРДН 1 Омск
Timeout=1.0
objectX=5500000
objectY=3700000
objectR=550000



# СПРО Воронеж
Timeout=1.0
objectX=3200000
objectY=3400000
objectR=1100000


