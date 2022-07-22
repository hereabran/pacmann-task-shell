#!/bin/bash

# Check installed python and csvkit
command -v python 1>/dev/null || command -v python3 1>/dev/null || (echo "Install Python to run the program" && exit 1)
command -v csvlook 1>/dev/null || (echo "Run `pip install csvkit` to run the program" && exit 1)

# Stack CSV
echo -e "\033[36m[CSVSTACK] Stack two CSV data into one\033[0m at data/2019-Oct-Nov.csv\n"
csvstack data/2019-Oct-sample.csv data/2019-Nov-sample.csv > data/2019-Oct-Nov.csv

# Filtering data to get sales activity only
echo -e "\033[36m[CSVCUT] Filtering data to get sales activity only\033[0m at data/filtered_2019-Oct-Nov.csv\n"
csvcut -c event_time,event_type,product_id,category_id,brand,price,category_code data/2019-Oct-Nov.csv > data/filtered_2019-Oct-Nov.csv

# Splitting category_code column to 2 columns
echo -e "\033[36m[CSVCUT] Splitting category_code column to 2 columns\033[0m at data/2019-Oct-Nov_category_product_name.csv\n"
echo "category,product_name" > data/2019-Oct-Nov_category_product_name.csv
csvcut -c category_code data/filtered_2019-Oct-Nov.csv | tail -n +2 | awk -F "." 'OFS="," {print $1, $NF}' >> data/2019-Oct-Nov_category_product_name.csv

# Join the columns from two files into one
echo -e "\033[36m[CSVJOIN] Join the columns from two files into one\033[0m at data/data_clean.csv\n"
csvjoin data/filtered_2019-Oct-Nov.csv data/2019-Oct-Nov_category_product_name.csv | csvcut -c event_time,event_type,product_id,category_id,brand,price,category,product_name > data/data_clean.csv

echo -e "\033[36mData Cleaned √ \033[0"
