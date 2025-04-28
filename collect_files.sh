#!/bin/bash

parametrs_check() {
    if (( $# != 2 )); then
        echo "Ошибка: требуется два параметра; Корректное использование скрипта: $0 /path/to/input_dir /path/to/output_dir"
        exit 1 
    fi
}

unique_name() {
    local k = 1
    local cur_name = "$1"
    local dir = "$2"
    local new_name = "$cur_name"
    while test -e "$dir/$new_name"; do
                new_name="$(
                    echo "${cur_name%.*}.$k."
                    echo "${cur_name##*.}"
                )"
                ((k+=1))
            done
            echo "$new_name"
}

files_copying() {
    local from_dir="$1"
    local to_dir="$2"
    for element in "$from_dir"/*; do
        local name="${element##*/}"
        local to_file="$to_dir/$name"
        if test -f "$element"; then
            to_file = $(unique_name "$name" "$to_dir")
            cp "$element" "$to_file"
           
        elif test -d "$element"; then
            mkdir -p "$to_file"
            files_copying "$element" "$to_file"
        fi
    done
}

parametrs_check "$@"
input_dir="$1"
output_dir="$2"
files_copying "$input_dir" "$output_dir"
echo "Все файлы скопированы из "$input_dir" в "$output_dir""