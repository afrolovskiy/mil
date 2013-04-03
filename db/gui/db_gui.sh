#!/bin/bash

MYSQL_HOST="192.168.222.182"
MYSQL_USER="root"
MYSQL_PASSWORD="123"

mysql -h $MYSQL_HOST -u $MYSQL_USER -p"$MYSQL_PASSWORD" -sse "SELECT * FROM medicines" medicines | while read i
do
	echo $i
done


zenity --list \
       --title="Аптеки "\
       --text="Список аптек" \
       --width=600 \
       --height=400 \
       --column="Наименование" --column="Адрес" --column="Часы работы" \
       	 1 Morning "Good morning" \
         2 Afternoon "Good Afternoon" \
         3 Evening "Good evening" \
