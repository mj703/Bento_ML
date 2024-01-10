#!/bin/bash

# Define input log file
LOG_FILE="opcron.txt"

# Create JSON file
JSON_FILE="cronstat.txt"

# Extract and format logs into JSON
awk '{print "{\"cron_stats\": { \"completion_time\": \""$1" " $2"\", \"Task\": "}' "$LOG_FILE" > file1.txt
cat "$LOG_FILE" | cut -d']' -f3 | cut -d' ' -f2-15 | cut -d'=' -f1 > file2.txt
cat "$LOG_FILE" | cut -d']' -f3 | cut -d' ' -f2-15 | cut -d'=' -f2 > file3.txt
sed -i -e 's/[[:blank:]]*$//g' -e 's/\ /_/g' -e 's/^/"/g' -e 's/$/"/g' file2.txt
sed -i -e 's/\ / "/g' -e 's/$/"/g' -e 's/^/, "value"\:/g' -e 's/$/} }/' file3.txt

# Combine JSON components
i=1
END=$(wc -l file1.txt | cut -d' ' -f1)
truncate -s 0 "$JSON_FILE"
for i in $(seq 1 $END); do
    var1=$(sed -n "${i}p" file1.txt)
    var2=$(sed -n "${i}p" file2.txt)
    var3=$(sed -n "${i}p" file3.txt)
    var4="$var1$var2$var3"
    echo "$var4" | tee -a "$JSON_FILE"
done

# Cleanup temporary files
rm -rf file1.txt file2.txt file3.txt

echo "Conversion completed. JSON data saved in $JSON_FILE"
