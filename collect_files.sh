#!/bin/bash

parametrs_check() {
    if (( $# != 2 )); then
        echo "Ошибка: требуется два параметра; Корректное использование скрипта: $0 /path/to/input_dir /path/to/output_dir"
        exit 1 
    fi
}

files_copying() {
    local from_dir="$1"
    local to_dir="$2"
    for element in "$from_dir"/*; do
        local name="${element##*/}"
        local to_file=$(printf "%s/%s" "$to_dir" "$name")
        if test -f "$element"; then
            local k=1
            while test -e "$to_file"; do
                to_file=$(printf "%s/%s.%d.%s" "$to_dir" "${name%.*}" "$k" "${name##*.}")
                ((k+=1))
            done
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