#!/bin/bash
# author fancy 2016.6.13
# version 3.01
# 合服脚本

source ./m_config.sh

function auto()
{
	echo "[$GAME]"
	read -p "确认合服:$* ?[y/n]" Answer
	case $Answer in
		y ) 
			start_auto_merge $* ;;
		* ) ;;
	esac
}

function start_auto_merge()
{
	read -p "输入合服次数n > 0:" MergeN
    read -p "是否检查表结构?[y/n]" CheckDB
    echofun "同步备份数据到本地.."
    data_sync_local
    echofun "初始化数据库:$*"
    init_db "$*"
    if [ "$CheckDB" == "y" ];then
            echofun "检查数据库:arpg$1"
            checkView=`check "arpg$1"`
            checkRet=`echo $checkView|grep "没有在处理列表"|wc -l`
            if [ $checkRet -gt 0 ];then
                    echo $checkView
                    echofun "合服程序版本错误"
                    exit 1
            fi
    fi
    echofun "开始合服:"
    merge_cmd=`config_cmd "$*" $MergeN`
    eval $merge_cmd
    echofun "导出数据库:arpg$1"
    dump_db2 "arpg$1"
    echofun "传输数据表开始.."
    data_sync_center
    echofun "合服$*结束!"
}


##合服主函数
function main()
{
	master=$1
	mtype=$2
	slave=$3
	stype=$4
	level=$5
	if [ -z "$master" ];then
		echofun "主库输入错误，退出。"
		exit 1
	fi
	if [ -z "$slave" ];then
		echofun "从库输入错误，退出。"
		exit 1
	fi
	
	if [ -z "`db_exists $master`" ];then
		echofun "主库不存在，退出。"
		exit 1
	fi
	if [ -z "`db_exists $slave`" ];then
		echofun "从库不存在，退出。"
		exit 1
	fi
	#1
	echofun "删除数据开始 .."
	clean_log $master
	clean_log $slave
	truncate_table $master $slave
	echofun "删除数据结束 ！"
	#2
	if [ $mtype == "del" ];then
		##echofun "备份[$master].."
		##backup_db $master
		echofun "删除[$master]玩家"
		del_player $master 0 $level
		add_merge_log $master $master
	fi

	if [ $stype == "del" ];then
		##echofun "备份[$slave].."
		##backup_db $slave
		echofun "删除[$slave]玩家"
		del_player $slave 0 $level
		add_merge_log $master $slave
	fi
	#3
	echofun "重名玩家修改"
	rename_player $master $slave 0
	echofun "重名仙盟修改"
	rename_guild $master $slave 0

	echofun "更新表自增ID"
	update_auto_ids $master $slave

	#4
	echofun "导出从库数据"
	dump_db $slave
	echofun "合并数据库开始"
	merge_master_db $master $slave
	echofun "合并后数据处理"
	clean_relation $master 0
	echofun "合并数据库结束！"

}

## 检查是否有没处理的表
function check()
{
	DBNAME=$1
	TABLES=(`mysql_exec $DBNAME "show tables"`)
	len=${#TABLES[@]}
	for((i=1;i<$len;i++))
	do
		local find=0
		if [ -n "`echo ${TABLES[i]} |grep '^log_'`" ];then
			find=1
			continue
		fi
		for tb in ${IGNORE_TABLES[@]}
		do
			if [ "$tb" == "${TABLES[i]}" ];then
				find=1
				continue
			fi
		done
		for tb in ${TRUNCATE_TABLES[@]}
		do
			if [ "$tb" == "${TABLES[i]}" ];then
				find=1
				continue
			fi		
		done
		for tb in ${DELETE_PLAYER_TABLES[@]}
		do
			tb=`echo $tb|awk -F "," '{print $1}'`
			if [ "$tb" == "${TABLES[i]}" ];then
				find=1
				continue
			fi
		done
		for tb in ${AUTO_TABLES[@]}
		do
			tb=`echo $tb|awk -F "," '{print $1}'`
			if [ "$tb" == "${TABLES[i]}" ];then
				find=1
				continue
			fi
		done
		if [ $find != 1 ];then
			echofun ${TABLES[i]} "没有在处理列表内"	
		fi
	done	
}

## 删除arpg*前缀数据库，arpg50001 除外
function clean_databases()
{
	mysql -uroot -p$(cat /data/mysql ) -e "show databases" | grep -v "arpg50001" |grep "arpg" | while read table;  do echo "drop $table" ; mysql -uroot -p$(cat /data/mysql) -e "drop database $table" ; done
}

function test()
{
	DBNAME=$1
	create_tmp_table $DBNAME
	copy_player $DBNAME 0
}

##删除模式
function del_player()
{
	DBNAME=$1
	offset=$2
	level=$3
	Now=`date +'+%s'`
	if [ "$level" = 1 ];then
		DTime15=$(( $Now - 86400 * 10 ))
		Rows=`mysql_exec $DBNAME "select DISTINCT pl.pkey from player_login as pl
				LEFT JOIN player_state as ps ON pl.pkey = ps.pkey   
				LEFT JOIN player_recharge as pr ON pl.pkey=pr.pkey
			where 			
		 	ps.lv < 51 and pl.last_login_time < $DTime15 and (pr.total_fee <=0 or isnull(pr.total_fee)) 
		 	ORDER BY pl.reg_time ASC
		 	limit $offset,100"`
	elif [ "$level" = 2 ];then
		DTime15=$(( $Now - 86400 * 10 ))
		Rows=`mysql_exec $DBNAME "select DISTINCT pl.pkey from player_login as pl
				LEFT JOIN player_state as ps ON pl.pkey = ps.pkey   
				LEFT JOIN player_recharge as pr ON pl.pkey=pr.pkey
			where 			
	 		ps.lv < 56 and pl.last_login_time < $DTime15 and (pr.total_fee <=0 or isnull(pr.total_fee)) 
	 		ORDER BY pl.reg_time ASC
	 		limit $offset,100"`
	elif [ "$level" = 3 ];then
	 	DTime15=$(( $Now - 86400 * 20 ))
		Rows=`mysql_exec $DBNAME "select DISTINCT pl.pkey from player_login as pl
				LEFT JOIN player_state as ps ON pl.pkey = ps.pkey   
				LEFT JOIN player_recharge as pr ON pl.pkey=pr.pkey
			where 			
	 		ps.lv < 81 and pl.last_login_time < $DTime15 and (pr.total_fee <=0 or isnull(pr.total_fee)) 
	 		ORDER BY pl.reg_time ASC
	 		limit $offset,100"`	
	elif [ "$level" = 4 ];then
	 	DTime15=$(( $Now - 86400 * 30 ))
		Rows=`mysql_exec $DBNAME "select DISTINCT pl.pkey from player_login as pl
				LEFT JOIN player_state as ps ON pl.pkey = ps.pkey   
				LEFT JOIN player_recharge as pr ON pl.pkey=pr.pkey
			where 			
	 		ps.lv < 56 and pl.last_login_time < $DTime15 and (pr.total_fee <=600 or isnull(pr.total_fee)) 
	 		ORDER BY pl.reg_time ASC
	 		limit $offset,100"`
	else  			
		echofun "del level $level error! "
		exit 0
	fi 
			 		
	if [ -z "$Rows" ];then
		echofun "玩家删除完毕"
		return
	else
		echofun "数据删除中:$offset"
		KeysArr=($Rows)
		KeyLen=${#KeysArr[@]}
		for((i=0;i<$KeyLen;i++))
		do
		{
			
			Pkey=${KeysArr[i]}
			for ii in ${DELETE_PLAYER_TABLES[@]}
			do
			{
				table=`echo $ii|awk -F "," '{print $1}'`
				field=`echo $ii|awk -F "," '{print $2}'`
				field2=`echo $ii|awk -F "," '{print $3}'`
				mysql_exec $DBNAME "delete from $table where $field = '$Pkey'"
				if [ -n "$field2" ];then
					mysql_exec $DBNAME "delete from $table where $field2 = '$Pkey'"
				fi	

			}
			done
			
		}&
		done
		wait
		del_player $1 `expr $offset + 100` $level
	fi
}

##创建临时表
function create_tmp_table()
{
	DBNAME=$1
	for i in ${DELETE_PLAYER_TABLES[@]}
	do
		table=`echo $i|awk -F "," '{print $1}'`
		field=`echo $i|awk -F "," '{print $2}'`
		mysql_exec $DBNAME "DROP TABLE IF EXISTS t_m_$table"
		mysql_exec $DBNAME "CREATE TABLE t_m_$table LIKE $table"
	done

}

## 重名玩家处理
function rename_player()
{
	master=$1
	slave=$2
	offset=$3
	Rows=`mysql_exec $master "select pkey, nickname ,lv from player_state limit $offset,100"`
	if [ -z "$Rows" ];then
		return
	else 
		PlayerArr=(${Rows#*lv})
		PlayerLen=${#PlayerArr[@]}
		#echofun $PlayerLen
		for((i=0;i<$PlayerLen;i++))
	    do
	    {
	    	if(((i+1)%3 == 0));then
	    	#-----	
	    	Pkey=${PlayerArr[i-2]}
	    	Nickname=${PlayerArr[i-1]}
	    	Lv=${PlayerArr[i]}
	    	SearchSlave=`mysql_exec $slave "select pkey,nickname ,lv from player_state where nickname='$Nickname'"`
	    	if [ -z "$SearchSlave" ]; then
	    		continue
	    	else
	    		##重名修改名字
	    		PlayerInfo=${SearchSlave#*lv}
	    		Pkey2=`echo $PlayerInfo |awk '{print $1}'`
	    		Nickname2=`echo $PlayerInfo |awk '{print $2}'`
	    		Lv2=`echo $PlayerInfo | awk '{print $3}'`
	    		if [ $Lv -gt $Lv2 ];then
	    			echofun "重名修改[$slave][$Nickname2][$Pkey2]"
	    			send_sys_mail $master $Pkey2 $Nickname2 1026000
	    			rname="$Nickname2$Lv2"
	    			mysql_exec $slave "update player_state set nickname='$rname' where pkey = '$Pkey2'"
	    		else
	    			echofun "重名修改[$master][$Nickname][$Pkey]"
	    			send_sys_mail $master $Pkey $Nickname 1026000
	    			rname="$Nickname$Lv"
	    			mysql_exec $master "update player_state set nickname='$rname' where pkey = '$Pkey'"
	    		fi
	    	fi
	    	#---
	    	fi
	    }
	    done
	    rename_player $1 $2 `expr $offset + 100`
	fi
}

##重名仙盟处理
function rename_guild()
{
	master=$1
	slave=$2
	offset=$3
	Rows=`mysql_exec $master "select gkey,name,pkey,lv from guild limit $offset,100"`
	if [ -z "$Rows" ];then
		return
	else 
		GuildArr=(${Rows#*lv})
		GuildLen=${#GuildArr[@]}
		#echofun $PlayerLen
		for((i=0;i<$GuildLen;i++))
	    do
	    {
	    	if(((i+1)%4 == 0));then
	    	#-----	
	    	Gkey=${GuildArr[i-3]}
	    	Name=${GuildArr[i-2]}
	    	Pkey=${GuildArr[i-1]}
	    	Lv=${GuildArr[i]}
	    	SearchSlave=`mysql_exec $slave "select gkey,name ,pkey,lv from guild where name='$Name'"`
	    	if [ -z "$SearchSlave" ]; then
	    		continue
	    	else
	    		##重名修改名字
	    		GuildInfo=${SearchSlave#*lv}
	    		Gkey2=`echo $GuildInfo |awk '{print $1}'`
	    		Name2=`echo $GuildInfo |awk '{print $2}'`
	    		Pkey2=`echo $GuildInfo | awk '{print $3}'`
	    		Lv2=`echo $GuildInfo | awk '{print $4}'`
	    		if [ $Lv -gt $Lv2 ];then
	    			echofun "仙盟重名修改[$slave][$Name2][$Gkey2]"
	    			send_sys_mail $master $Pkey2 $Name2 1026001
	    			rname="$Name2$Lv2"
	    			mysql_exec $slave "update guild set name='$rname' where gkey='$Gkey2'"
	    		else
	    			echofun "仙盟重名修改[$master][$Name][$Gkey]"
	    			send_sys_mail $master $Pkey $Name 1026001
	    			rname="$Name$Lv"
	    			mysql_exec $master "update guild set name='$rname' where gkey='$Gkey'"
	    		fi
	    	fi
	    	#---
	    	fi
	    }
	    done
	    rename_guild $1 $2 `expr $offset + 100`
	fi
}

## 删除关系表不存在key
function clean_relation()
{
	master=$1
	Rows=`mysql_exec $master "select rkey from relation where key1 not in (select pkey from player_state) or key2 not in(select pkey from player_state)"`
	RowArr=($Rows)
	for R in ${RowArr[@]};do
		mysql_exec $master "delete from relation where rkey = '$R'"
	done	
}

##初始化数据库
function init_db()
{
	local DBS=$*
    for DB in ${DBS[@]};do
            mysqlc "drop database if exists $PREFIX$DB"
            mysqlc "create database $PREFIX$DB"
            mysql_load $PREFIX$DB $DBFILE
            myloaderc $PREFIX$DB ./backup/$PREFIX$DB
            echofun "init $DB finish!"
    done	
}

##删除数据库
function drops_db()
{
	local DBS=$*
	for DB in ${DBS[@]};do
		mysqlc "drop database if exists $PREFIX$DB"
		echofun "drop $DB finish !"
	done	
}

##导出数据库 参数1
function dump_db()
{
	DBNAME=$1
	ensure_dir
	#导出从库
	$MYSQL_DUMP "-h$DB_HOST" "-u$DB_USER"  $DUMPOPT $DBNAME > "./sql/$DBNAME.sql"
}

##导出数据库 参数2
function dump_db2()
{
	DBNAME=$1
	ensure_dir
	$MYSQL_DUMP "-h$DB_HOST" "-u$DB_USER"  $DUMPOPT2 $DBNAME > "./sql/$DBNAME.sql"
}

##导出数据表
function dump_table()
{
	DBNAME=$1
	TABLENAME=$2
	WHERE=$3
	ensure_dir
	$MYSQL_DUMP "-h$DB_HOST" "-u$DB_USER"  $DUMPOPT $DBNAME $TABLENAME "--where=$WHERE" |grep "INSERT" >> "./sql/$DBNAME_$TABLENAME.sql"
}

##从库合并到主数据库
function merge_master_db()
{
	master=$1
	slave=$2
	#合并数据库
	#$MYSQL $SQLOPT  $master "--default-character-set=utf8 < ./sql/$slave.sql"
	mysql_exec $master "source ./sql/$slave.sql"
	rm -f ./sql/*.sql

}

##合服需清空的数据表
function truncate_table()
{
	master=$1
	slave=$2
	for i in ${TRUNCATE_TABLES[@]}
	do
		mysql_exec $master "TRUNCATE TABLE $i"
	done

	for ii in ${TRUNCATE_TABLES[@]}
	do
		mysql_exec $slave "TRUNCATE TABLE $ii"
	done
}

##删除主库从库的日志
function clean_log()
{
	DBNAME=$1
	LogTable=`mysql_exec $DBNAME "show tables"|grep ^log_ `
	LogTableArr=($LogTable)
	for i in ${LogTableArr[@]}
	do
		mysql_exec $DBNAME "TRUNCATE TABLE $i"
	done
}

##更新从库的自增ID
function update_auto_ids()
{
	master=$1
	slave=$2
	for i in ${AUTO_TABLES[@]}
	do
		table=`echo $i|awk -F "," '{print $1}'`
		field=`echo $i|awk -F "," '{print $2}'`
		maxid=`get_max_id $master $table $field`
		if [ $maxid != NULL ];then	
			mysql_exec $slave "update $table set $field=$field+$maxid where $field > 0 order by $field DESC"
		fi
	done
}


##发送系统邮件
function send_sys_mail()
{
	local DBNAME=$1
	local Pkey=$2
	local Nickname=$3
	local GoodsId=$4
	mysql_exec $DBNAME "REPLACE INTO merge_mail (pkey,goodstype,state,nickname) VALUES ($Pkey,$GoodsId,0,'$Nickname')"
	echofun "send_sys_mail"
}

##添加合服日志
function add_merge_log()
{
	local MASTER=$1
	local DBNAME=$2
	local SN=`echo $DBNAME | sed 's/[a-z]*//'`
	local Now=`date +'%s'`
	mysql_exec $MASTER "INSERT INTO merge_info set time = $Now ,sn = $SN"
	echofun "add_merge_log"
}

##@@@@辅助函数@@@@##

function mysql_exec()
{
        DBNAME=$1
        SQLSTR=$2
        $MYSQL "-h$DB_HOST" "-u$DB_USER" $SQLOPT <<EOF
        use $DBNAME;
        set names utf8;
        $SQLSTR;
EOF
}

function mysqlc()
{
        SQLSTR=$1
        $MYSQL "-h$DB_HOST" "-u$DB_USER" $SQLOPT <<EOF
        $SQLSTR;
EOF
}

function mysql_load(){

		DBNAME=$1
		LOADPATH=$2
		$MYSQL "-h$DB_HOST" "-u$DB_USER" $DBNAME < $LOADPATH
}

function mydumper()
{
        mydumper -u root -p $(cat /data/mysql) -B db -o db.sql
}

function myloaderc()
{
		DBNAME=$1
		LOADPATH=$2
		$MYLOADER -u $DB_USER -p $MYSQL_PWD -B $DBNAME -d $LOADPATH
}

function echofun()
{
		local t=`date +'%H:%M:%S'`
        echo "|+++++ $t +++++|$@" 
}

function config_cmd()
{
	local srvs=$1
	local level=$2
	if [ x$2 = x ];then
		echofun "args error !"
		exit 0
	fi	
	local n=0
	local cmd=''
	for i in ${srvs[@]};do
		if [ $n == 0 ];then
				from=$i
		elif [ -z "$cmd" ];then
				cmd="./m.sh main $PREFIX$from del $PREFIX$i del $level"		
        else
                cmd=$cmd" && ./m.sh main $PREFIX$from skip $PREFIX$i del $level"
        fi
        n=$n+1
    done
	echo $cmd
}

function ensure_dir(){
	if [ ! -d "./sql" ]; then
		mkdir -p sql
	fi
}

function db_exists()
{
        DBNAME=$1
        echo `mysql_exec $DBNAME "SHOW DATABASES;"|grep $DBNAME`
}

function get_max_id()
{
	DBNAME=$1
	TABLE=$2
	FILED=$3
	maxid=`mysql_exec $DBNAME "select max($FILED) as max from $TABLE"|awk 'NR==2{print $1}'`
	if [ $maxid = NULL ];then
		echo 10000
	else
		echo `expr $maxid + 10000`
	fi
}

##同步中心服备份数据到合服机器
function data_sync_local()
{
	/usr/bin/rsync -e "ssh -p $CENTER_PORT" -avz --delete root@$CENTER_IP:/data/ctl/backup ./
	##需要同步对应版本sql结构到本地
	/usr/bin/rsync -e "ssh -p $CENTER_PORT" -avz --delete root@$CENTER_IP:/data/release/arpg/sql/arpg.sql ./
}

##同步合服完毕的sql文件到中央服
function data_sync_center()
{
	scp -P $CENTER_PORT ./sql/*.sql root@$CENTER_IP:/data
}

if [ $# -eq 0 ];then
	echo "Usage: ./m.sh main dbname1 type1 dbname2 type2 (type=copy or del or skip)"
	exit 1
fi

 # ----------- menus ------------ #
case $1 in
auto)
	auto $2
;;	
main)
	main $2 $3 $4 $5 $6
;;
test)
	test $2
;;
check)
	check $2
;;
clean)
	clean_databases	
;;
init)
	init_db $2
;;
drop)
	drops_db $2
;;
dump)
	dump_db2 $2
;;
config)
	config_cmd "$2" $3
;;
esac


