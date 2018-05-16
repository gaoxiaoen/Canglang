#!/bin/bash
#author fancy
#游戏维护脚本 v2

source ./config.sh
ROOT=`cd $(dirname $0); pwd`/../
LOGDIR=$ROOT/logs
CFGDIR=$ROOT/config
EBINDIR=$ROOT/ebin
DATETIME=`date "+%Y%m%d-%H%M%S"`
SMP_LIMIE=604800 #三天秒
export ERL_CRASH_DUMP=$LOGDIR/erl_crash_$DATETIME.dump
export ERL_MAX_PORTS=102400
export ERL_MAX_ETS_TABLES=10000
export HOME=$ROOT
export HOMEPATH=$ROOT/config
time=`date +%s`
ARGS=$1
AUTO_SMP=1  #0为固定开启
CENTER_NAME="center"
CENTER_NUM=20

cd $CFGDIR

if [ ! -d $LOGDIR ]; then
    mkdir -p $LOGDIR || print "make $LOGDIR error!"; exit 1
fi

OPTS=" +P 1024000 +K true +spp true +sbwt none +sub true +pc unicode +zdbbl 81920 -hidden true -kernel dist_auto_connect never -boot start_sasl -config $CFGDIR/server -pa $EBINDIR"
EXTRA_OPTS='$SERVER_NUM $IP $PORT $OPENTIME $TICK $LOG_LEVEL $DEBUG $DB_HOST $DB_PORT $DB_USER $DB_PASS $DB_NAME $OS'

usage() 
{
    echo ""
    echo "用法:"
    echo "$0 ACTION [OPTION]"
    echo "ACTION:"
    echo " start  后台方式启动"
    echo " test   交互方式启动"
    echo " restart  重启"
    echo " stop 关闭"
    echo " center 1 启动跨服节点 1"
    echo " center stop 关闭所有跨服节点"
    echo " hotfix 1 热更新 1分钟内修改文件"
    echo " hotfun Module Method 调用游戏内部函数"
    echo " hotres 通知客户端热更资源"
    echo ""

}

# 打印错误
error() {
    echo -e "[1;41m[错误][0m $1"
    exit 1
}

# 打印信息
print() {
    echo -e "[1;42m[操作][0m $1"
}

# 打印警告
warn() {
    echo -e "[1;43m[警告][0m $1"
}

# 是否已运行
function is_started()
{
  res=`screen -ls |awk '{print $1}' |grep $GAME$ |awk -F '.' '{print $1}'|wc -l`
  if [ $res -eq 0 ];then
     return 1 
  else
     return 0
  fi
}

# 关闭进程
function kill_all()
{
  local res=`screen -ls |awk '{print $1}' |grep $GAME$ |awk -F '.' '{print $1}'|wc -l`
  if [ $res -gt 0 ];then
  screen -ls |awk '{print $1}' |grep $GAME$ |awk -F '.' '{print $1}'|xargs kill
  fi  
}

# 是否开启SMP
function is_open_smp()
{
  if [ $AUTO_SMP -eq 1 ];then
    if [ $DEBUG -eq 0 ];then
        if [ $SERVER_NUM -gt 50000 -o $OPENTIME -gt 0  -a $(($time - $OPENTIME)) -lt $SMP_LIMIE ];then
          return 0
        fi
        return 1
    else  
      return 1  
    fi
  else
    return 0
  fi     
}

#端口是否被占用
function is_port_vaild()
{
  local port=$1
  if [ $OS = 'mac' ];then
     local res=`lsof -nP -iTCP:$port -sTCP:LISTEN |wc -l` #mac
  else   
     local res=`netstat -tnpl|grep :$port|wc -l` #linux
  fi
  if [ $res -gt 0 ];then
      warn "$port 被占用" 
      return 1
  else
      return 0
  fi         
}

function start_game()
{
  sleep 6
  if is_started ;then
    warn "失败 ！$GAME 已启动！"
  else
    start_node
    sleep 5
    if is_started ;then
      print "$GAME 已启动！"
    else
      error "$GAME 启动失败，请查看日志！"  
    fi  
  fi    
}

function stop_game(){
    dostop
    sleep 10
    kill_all
    print "$GAME 已关闭！"
}

function start_node()
{
  local live=$1
  if is_open_smp;then
    SMP="enable"
  else
    SMP="disable"
  fi
  if is_port_vaild $PORT ;then
    local EXTRA_OPTS=`eval echo $EXTRA_OPTS`
    if [ "$live" = true ];then
      $ERL -smp $SMP -name ${GAME}@$IP -setcookie $GAME $OPTS -s game server_start -extra $EXTRA_OPTS
    else  
      screen -dmS ${GAME} $ERL -smp $SMP -name ${GAME}@$IP -setcookie $GAME $OPTS -s game server_start -extra $EXTRA_OPTS
    fi
  fi  
}

function start_center()
{
    SERVER_NUM=50001
    if [ -n "$1" -a "$1" -ge 0 ];then
      local n=$1
    else
      local n=0
    fi 
    local live=$2
    print $n   
    PORT=`expr 20000 + 10 \* $n`
    if is_port_vaild $PORT ;then
      local EXTRA_OPTS=`eval echo $EXTRA_OPTS`
      if [ "$live" = true ];then
        $ERL -smp enable -name $CENTER_NAME$n@$IP -setcookie cl168arpg $OPTS -s game server_start -extra $EXTRA_OPTS
      else  
        screen -dmS $CENTER_NAME$n $ERL -smp enable -name $CENTER_NAME$n@$IP -setcookie cl168arpg $OPTS -s game server_start -extra $EXTRA_OPTS
      fi  
    fi  
}

function start_centerall()
{
  for((n=0;n<=$CENTER_NUM;n++));
  do
      sleep 2
      start_center $n
  done
}

function stop_center()
{

    if  [ $SERVER_NUM == 30001 ];then
        ps aux |grep "$CENTER_NAME[0-2]\+" |awk '{print $2}'|xargs kill
        print "关闭 $CENTER_NAME !"
    else
        ps aux |grep "$CENTER_NAME[0-9]\+" |awk '{print $2}'|xargs kill
        print "关闭 $CENTER_NAME !"
    fi
}

function teststart()
{
  start_node true 
}

function testcenter()
{
    start_center 0 true
}

function robotnum()
{
  num=$1
  $ERL +P 1024000 -pa ../ebin -name robot@127.0.0.1 -s robot start $IP $PORT $num
}

function rpc2game()
{
	module=$1
	method=$2
	query=$3
	port2=`expr ${PORT} + 1`
	qid="cl168"
  if [ $OS = 'mac' ];then
	   auth=`echo -n $qid$time$TICK|openssl md5` #mac
  else   
	   auth=`echo -n $qid$time$TICK|md5sum|awk '{print $1}'` #linux
  fi   
	url="http://127.0.0.1:${port2}/${module}/${method}?timestamp=${time}&auth=${auth}&qid=${qid}&${query}"
	print $url
	curl $url
}

function dostop()
{
	rpc2game 'sys' 'stop'
	echo -e "\n"
}

function dohotfix()
{
	time=$1
	rpc2game 'sys' 'hotfix' "min=${time}"
	echo -e "\n"
}

function dohotfun()
{
	module=$1
	method=$2
	rpc2game 'sys' 'hotfun' "module=${module}&method=${method}"
	echo -e "\n"
}

function dohotres()
{
	module=$1
	method=$2
	args=$3
	rpc2game 'sys' 'hotres' "module=${module}&method=${method}&args=${args}"
	echo -e "\n"
}

function domake()
{
  cd $HOME
  $ERL -pa ebin -make all
}

function restart_center(){
    if [ $SERVER_NUM == 30001 ];then
        sleep 3
        stop_center
        sleep 2
        start_center 0
        start_center 1
        start_center 2
        print "启动 $CENTER_NAME !"
    elif [ $SERVER_NUM == 30003 ];then
        sleep 3
        stop_center
        sleep 2
        start_center 3
        print "启动 $CENTER_NAME !"
    else
        warn "服务器号异常！"
    fi
}


function reboot_warning()
{
    rpc2game 'sys' 'reboot_warning'
    echo -e "\n"
}


case "$ARGS" in
  start) start_game ;;
  stop)  stop_game & ;;
  restart) stop_game & start_game & restart_center ;;
  test) teststart ;;
  testcenter) testcenter $2 ;;
  rw) reboot_warning ;;
  center)
    case $2 in
      stop)
        stop_center ;;
      all)
       start_centerall ;;
        *)
          start_center $2 ;;
    esac      
  ;;
  robot) robotnum $2 ;;
  make) domake ;;
  hotfix) dohotfix $2 ;;
  hotfun) dohotfun $2 $3 ;;
  hotres)  dohotres $2 $3 $4 ;;
  checkport) is_port_used $2 ;;
  *) usage ;;
esac

