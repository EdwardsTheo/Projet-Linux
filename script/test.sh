#! /bin/bash
while IFS="," read -r rec_column1 rec_column2 rec_column3
do
  if [ $rec_column1 == $1 ]; then
  	echo $rec_column1 
  fi
done < <(tail -n +2 ../csv/MonDns.csv)
