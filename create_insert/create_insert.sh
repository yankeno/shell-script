#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_file table_name"
    exit 1
fi

# 入力ファイル名
input_file="$1"

# テーブル名
table_name="$2"

# 出力ファイル名の初期値
output_file="insert_${table_name}.sql"

# 既存の出力ファイルがある場合、末尾に番号を追加
i=2
while [ -e "${output_file}" ]; do
    output_file="insert_${table_name}${i}.sql"
    i=$((i + 1))
done

# ヘッダー行を読み込み、カラム名を抽出
header=$(head -n 1 "${input_file}")
columns=$(echo "${header}" | tr "\t" ", ")

# INSERT文のヘッダー部分を生成
echo "INSERT INTO \`${table_name}\` (${columns})" >"${output_file}"
echo "VALUES" >>"${output_file}"

# TSVファイルのデータ行を読み込み、INSERT文の値部分を生成
while IFS=$'\t' read -r -a line || [[ -n "${line[*]}" ]]; do
    values=""
    for val in "${line[@]}"; do
        if [[ "$val" =~ ^[1-9][0-9]*$ ]]; then
            values+="$val, "
        elif [[ "$val" == "null" ]]; then
            values+="null, "
        else
            values+="'$val', "
        fi
    done
    values=${values%, }
    echo "  (${values})," >>"${output_file}"
done < <(tail -n +2 "${input_file}")

# 最後のカンマをセミコロンに置換
sed -i '' -e '$ s/,$/;/' "${output_file}"

# ^M を削除
sed -i '' $'s/\r//' "${output_file}"
