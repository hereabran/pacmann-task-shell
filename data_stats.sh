#!/bin/bash

command -v python 1>/dev/null || command -v python3 1>/dev/null || (echo "Install Python to run the program" && exit 1)
command -v csvlook 1>/dev/null || (echo "Run `pip install csvkit` to run the program" && exit 1)

echo -e "\033[36m[CSVLOOK] Uncover top 10 from table\033[0m data/data_clean.csv \n"
cat data/data_clean.csv | head | csvlook
echo -e "\n"

echo -e "\033[36m[STAT] view most trending brand\033[0m data/data_clean.csv \n"
cat data/data_clean.csv | grep electronics | grep smartphone | awk -F ',' '{print $5}' | sort | uniq -c | sort -nr

