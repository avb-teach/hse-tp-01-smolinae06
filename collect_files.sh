#!/bin/bash

if (( $# != 2 )); then
    echo "Ошибка: требуется два параметра; Корректное использование скрипта: $0 /path/to/input_dir /path/to/output_dir"
    exit 1 
fi

input_dir="$1"
output_dir="$2"

files_copying(){
    local from_dir="$1"
    local to_dir="$2"
    for element in "$from_dir"/*; do
        if test -f "$element"; then
            local k=1
            local name="${element##*/}"
            local to_file="$to_dir/$name"
            while test -e "$to_file"; do
                to_file="$(
                    echo "${to_dir}/"
                    echo "${name%.*}.$k."
                    echo "${name##*.}"
                )"
                ((k+=1))
            done
            cp "$element" "$to_file"
            
        elif test -d "$element"; then
            mkdir -p "$to_dir/"${element##*/}""
            files_copying "$element" "$to_dir/"${element##*/}""
        fi
    done
}

files_copying "$input_dir" "$output_dir"
echo "Все файлы скопированы из "$input_dir" в "$output_dir""