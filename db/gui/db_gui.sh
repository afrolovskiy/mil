#!/bin/bash

MYSQL_HOST="192.168.222.182"
MYSQL_USER="root"
MYSQL_PASSWORD="123"

medicine_ids=`mysql -h $MYSQL_HOST -u $MYSQL_USER -p"$MYSQL_PASSWORD" -sse "SELECT id FROM pharmacies" medicines`
#echo $medicine_ids
#result=""
test ~/temp && rm ~/temp 
touch ~/temp
for id in $medicine_ids
do
	#echo $id
	name=`mysql -h $MYSQL_HOST -u $MYSQL_USER -p"$MYSQL_PASSWORD" -sse "SELECT name FROM pharmacies WHERE id=$id" medicines`
	#echo $name
	address=`mysql -h $MYSQL_HOST -u $MYSQL_USER -p"$MYSQL_PASSWORD" -sse "SELECT address FROM pharmacies WHERE id=$id" medicines`
	#echo $address
	working_time=`mysql -h $MYSQL_HOST -u $MYSQL_USER -p"$MYSQL_PASSWORD" -sse "SELECT working_time FROM pharmacies WHERE id=$id" medicines`
	#echo $working_time
	result+="$id \"$name\" \"$address\" \"$working_time\" "
	
	echo "$id \"$name\" \"$address\" \"$working_time\" " >> ~/temp
done

echo $result


#result=`cat ~/temp | sed 's/"/\"/g'`
echo $result
cat ~/temp | zenity --list \
       --title="Аптеки "\
       --text="Список аптек" \
       --width=1000 \
       --height=400 \
       --column="id" --column="Наименование" --column="Адрес" --column="Часы работы" \
       
