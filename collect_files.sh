#!/bin/bash

if (( $# != 2 )); then
    echo "Ошибка: требуется два параметра; Корректное использование скрипта: $0 /path/to/input_dir /path/to/output_dir"
    exit 1 
fi

input_dir="$1"
output_dir="$2"

if test ! -d "$input_dir"; then
    echo "Ошибка: входная директория "$input_dir" не существует"
    exit 1
fi

if test ! -d "$output_dir"; then
    mkdir -p "$output_dir"
fi

files_copying() {
    local from_dir="$1"
    local to_dir="$2"
    for element in "$from_dir"/*; do
        if test -f "$element"; then
            local name=$(basename "$element")
            local to_file="$to_dir/$name"
            local k=1
            while test -e "$to_file"; do
                to_file="$(
                    echo "${to_dir}/"
                    echo "${name%.*}.$k."
                    echo "${name##*.}"
                )"
                ((++k))
            done
            cp "$element" "$to_file"
            
        elif test -d "$element"; then
            mkdir -p "$to_dir/$(basename "$element")"
            files_copying "$element" "$to_dir/$(basename "$element")"
        fi
    done
}

files_copying "$input_dir" "$output_dir"
echo "Все файлы скопированы из "$input_dir" в "$output_dir""