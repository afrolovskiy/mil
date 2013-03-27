#!/bin/bash

zenity --list \
       --title="Аптеки "\
       --text="Список аптек" \
       --width=600 \
       --height=400 \
       --column="Наименование" --column="Адрес" --column="Часы работы" \
       	 1 Morning "Good morning" \
         2 Afternoon "Good Afternoon" \
         3 Evening "Good evening" \
