#!/bin/bash

MYSQL_HOST="192.168.222.182"
MYSQL_USER="root"
MYSQL_PASSWORD="123"

medicine_ids=`mysql -h $MYSQL_HOST -u $MYSQL_USER -p"$MYSQL_PASSWORD" -sse "SELECT id FROM medicines" medicines`
echo $medicine_ids
for id in $medicine_ids
do
	echo $id
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
