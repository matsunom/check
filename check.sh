#!/bin/sh

#ディレクトリとデータベースの作成を行う

dirpath=$HOME"/check"
filepath=$HOME"/check/CHECK_TIME"

check_database() {
  if [ ! -e $dirpath ] ; then
    mkdir $dirpath
  fi

  cd $dirpath

  if [ ! -e $filepath ] ; then
    touch $filepath
    sqlite3 CHECK_TIME "CREATE TABLE projects ('ID' INTEGER PRIMARY KEY AUTOINCREMENT, 'NAME' TEXT, 'START' INTEGER, 'END' INTEGER)"
  fi

  cd - > /dev/null
}


#プログラムのステータスを確認する
check_status() {
    STATUS=`sqlite3 CHECK_TIME "SELECT COUNT(*) FROM projects WHERE START = 1"`
    if [ $STATUS = 1 ] ; then
      ID_STATUS=`sqlite3 CHECK_TIME "SELECT ID FROM projects WHERE START = 1"`
      NAME_STATUS=`sqlite3 CHECK_TIME "SELECT NAME FROM projects WHERE ID == $ID_STATUS"`
      START_STATUS=`sqlite3 CHECK_TIME "SELECT START FROM projects WHERE ID == $ID_STATUS"`
      return 1
    elif [ $STATUS = 0 ] ; then 
      return 0
    else
      exit
    fi
}

#プロジェクトの存在を確認する
check_project() {
  TABLE_STATUS=`sqlite3 CHECK_TIME "SELECT COUNT(*) FROM projects WHERE NAME = '$2'"`
  if [ $TABLE_STATUS = 1 ] ; then
    return 0
  elif [ $TABLE_STATUS = 0 ] ; then
    return 1
  fi
}

#プロジェクトの作成を行う
create_project() {
  sqlite3 CHECK_TIME "INSERT INTO projects ('NAME') VALUES ('$2')"
  sqlite3 CHECK_TIME "CREATE TABLE $2 ('ID' INTEGER PRIMARY KEY AUTOINCREMENT, 'START' DATETIME, 'END' DATETIME, 'MEMO' TEXT)"
}


#チェックインする
stamp_in() {
  check_status
  check_status_return=$?
  if [ $check_status_return = 0 ] ; then #実行状態check_status_return=0だった場合、最後にOUTされているので、INできる
    
    if [ -z "$2" ] ; then #projectが空文字列だと終了する
    echo "Please write a project name!"
    exit
    fi

    #テーブルの存在の確認
    check_project $1 $2
    check_project_return=$?
    if [ $check_project_return = 1 ] ; then #check_project_return=1だった場合、テーブルは存在しないので、projectsへの追加とprojectの作成を行う
      create_project $1 $2
    fi

    #チェックインを行う
    DATE=`date "+%Y-%m-%d %H:%M:%S"`
    echo "You can describe details of this activity! "
    printf "entry: "
    read memo
    sqlite3 CHECK_TIME "UPDATE projects SET START = 1 WHERE NAME = '$2'"
    sqlite3 CHECK_TIME "INSERT INTO $2 ('START', 'MEMO') VALUES ('$DATE', '$memo')"

    echo "Your check-in $2 is successful."
  
  elif [ $check_status_return = 1 ] ; then #実行状態check_status_return=1だった場合、最後はINなのでINできない
    echo "$NAME_STATUS is running. Please check out!"
    exit
  fi

  return 0
}

#データベースからINとOUTの時間の差分の秒数を抜き出し、HH:MM:SSの形式で表示する。
substraction_time() {
  get_time=`sqlite3 CHECK_TIME "SELECT STRFTIME('%s', END) - STRFTIME('%s', START) FROM $NAME_STATUS WHERE ID = $query_id"`
  hours=`expr $get_time / 3600`
  minute=`expr \( $get_time % 3600 \) / 60`
  second=`expr $get_time % 60`
  echo "Your check-out $NAME_STATUS is successful. This time is $hours:$minute:$second."
  return 0
}

#チェックアウトする。
stamp_out() {
  check_status
  check_status_return=$?
  if [ $check_status_return = 1 ] ; then #実行状態check_status_return=1だった場合、最後はINなのでOUTする

    #チェックアウトする
    DATE=`date "+%Y-%m-%d %H:%M:%S"`
    query_id=`sqlite3 CHECK_TIME "SELECT ID FROM $NAME_STATUS WHERE END IS NULL"`
    sqlite3 CHECK_TIME "UPDATE $NAME_STATUS SET END = '$DATE' WHERE ID = '$query_id'"
    sqlite3 CHECK_TIME "UPDATE projects SET START = 0 WHERE NAME = '$NAME_STATUS'"
    substraction_time  $NAME_STATUS $query_id

  elif [ $check_status_return = 0 ] ; then #実行状態check_status_return=1だった場合、最後はOUTなのでOUTできない
    echo "No projects is running!"
    exit
  fi
  return 0
}

#スクリプトの流れ
##データベースの存在確認
##実行状態の確認
###チェックイン
####テーブルの存在確認
###チェックアウト
####時間計算
main() {
  #コマンドの実行環境の確認
  check_database

  #$HOME/checkに移動する
  cd $dirpath
  #実行状態の確認
  if [ $1 = "in" ] ; then
    stamp_in $1 $2


  elif [ $1 = "out" ] ; then
    # stamp_out $1 $2
    stamp_out
  fi

  #元のディレクトリに移動する
  cd - > /dev/null
}

main $1 $2
