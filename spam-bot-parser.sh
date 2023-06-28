#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Please provide the path to the log file."
    exit 1
fi

log_file_path=""
unique_flag=false
ports_flag=false

# Process command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -u|--unique)
        unique_flag=true
        shift
        ;;
        -p|--ports)
        ports_flag=true
        shift
        ;;
        *)
        log_file_path=$1
        shift
        ;;
    esac
done

# i love regex!
filter_pattern=".*id=<null>.*"
name_pattern="name=([[:alnum:]]+)"
ip_pattern="([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+)"
# actually, i hate it with every fiber of my being...

if [ -z "$log_file_path" ]; then
    echo "Please provide the path to the log file."
    exit 1
fi

if [ ! -f "$log_file_path" ]; then
    echo "Log file not found: $log_file_path"
    exit 1
fi

if [[ $log_file_path == *.gz ]]; then
    log_content=$(gunzip -c "$log_file_path")
else
    log_content=$(cat "$log_file_path")
fi

# regex magic
filtered=$(echo "$log_content" | grep -Po "$filter_pattern")
names=$(echo "$filtered" | grep -Po "$name_pattern" | awk -F= '{print $2}')
ips=$(echo "$filtered" | grep -Po "$ip_pattern")

IFS=$'\n' read -rd '' -a name_array <<< "$names"
IFS=$'\n' read -rd '' -a ip_array <<< "$ips"

output=""

# arrang the output as "name;ip:port" for later use in csv files
for index in "${!name_array[@]}"; do
    name=${name_array[index]}
    ip=${ip_array[index]}
    
    if [ "$ports_flag" = true ]; then
        output+="$name;$ip"$'\n'
    else
        ip_without_port=${ip%:*}
        output+="$name;$ip_without_port"$'\n'
    fi
done

if [ "$unique_flag" = true ]; then
    unique_output=$(echo "$output" | sort -u)
    trimmed_output=$(echo "$unique_output" | sed '/^$/d')
    echo "$trimmed_output"
else
    echo "$output"
fi
