# TSV ファイルから INSERT 文を生成するスクリプト

## 使い方

- 以下ように入力ファイルとテーブル名を引数に渡して実行する。

```bash
$ bash create_insert.sh input_file table_name
```

- 実行に成功すると、スクリプトと同一ディレクトリに SQL ファイルが出力される。
- 出力ファイル名が重複する場合は insert_table_name2.sql のように数値を追加したファイル名で出力される
