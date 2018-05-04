#!/bin/bash
#---------------------------------------------------------------------
# author:  <caochuncheng2002@gmail.com>
# desc: 服务运维使用脚本，即通过此脚本管理游戏，启动，停止，更新，切机，备份等操作
# create_date: 2015-12-14
#---------------------------------------------------------------------

## 设置参数
ulimit -c unlimited
ulimit -SHn 51200

## 获取脚本执行目录
here=`which "$0" 2>/dev/null || echo .`
base="`dirname $here`"
SHELL_DIR=`(cd "$base"; echo $PWD)`

#--------------------------------------------------------------------------------------------------
# 脚本基本信息
# 游戏运行目录为：/data/games/xxx_yyy/v1.0.0/
# xxx：表示项目名称，即游戏代号，一般使用游戏的拼音表示，如：ssjd=蜀山剑道
# yyy：表示游戏平台名称，如：4399、37wan、360、qq等
# v1.0.0：游戏版本
# 根据以上的规则，即可以获得游戏运行的代码目录
# /data/games/ssjd_4399/v1.0.0/
#                              ----config                          配置文件
#                              ----ebin                            erlang代码beam
#
# 游戏Mnesia数据库目录为：/data/database/xxx_yyy_Sn
# /data/database/ssjd_4399_S1
#
# 游戏服配置目录如下：
# /data/games/ssjd/config/
#                    ----ssjd_4399_S1_common.config                   游戏服通用配置，即运维需要修改的配置
# 注：脚本的执行，必须是在setting
#--------------------------------------------------------------------------------------------------

# 操作结束并返回操作编码
# 返回码描述
EXIT_CODE_0=0          # 操作成功
EXIT_CODE_1=1          # 用户目录下没有.erlang.cookie文件，不可以在这台服务器启动脚本
EXIT_CODE_2=2          # Erlang 版本出错，请检查并联系开发人员
EXIT_CODE_3=3          # 配置文件xxx_yyy_zzz_common.config不存在，无法启动
EXIT_CODE_4=4          # 没有代码ebin目录，无法启动
EXIT_CODE_5=5          # 没有代码config目录，无法启动
EXIT_CODE_6=6          # 远程调用游戏节点执行命令出错，没有参数
EXIT_CODE_7=7          # 服务已经启动，启动失败
EXIT_CODE_8=8          # 服务不存在，停止失败
EXIT_CODE_9=9          # 当前服务正在运行，不可以执行此方式的更新
EXIT_CODE_10=10        # 取消脚本执行
EXIT_CODE_11=11        # 没有找到合服的数据，无法执行

EXIT_CODE_100=100      # 表示参数出错，无法执行
EXIT_CODE_101=101      # 节点参数出错
EXIT_CODE_102=102      # 执行的动作参数出错
EXIT_CODE_103=103      # 此命令无法执行
EXIT_CODE_104=104      # 远程调用游戏节点执行命令出错

EXIT_CODE_110=110      # 服务正在运行无法启动
EXIT_CODE_111=111      # 数据库schema.DAT加载失败
EXIT_CODE_112=112      # 数据表信息出错
EXIT_CODE_113=113      # 数据表节点信息出错
EXIT_CODE_114=114      # master_host 配置出错
EXIT_CODE_115=115      # erlang_web_port 配置出错
EXIT_CODE_116=116      # erlang_web_port 程序无法监听此端口
EXIT_CODE_117=117      # gateway 配置出错
EXIT_CODE_118=118      # gateway 程序无法监听此端口
EXIT_CODE_119=119      # 日志节点无法连通

EXIT_CODE_120=120      # 日志数据库配置出现重复配置
EXIT_CODE_121=121      # 日志数据库连接失败
EXIT_CODE_122=122      # 更新数据库操作出错，当前没有数据库文件
EXIT_CODE_123=123      # 更新数据库操作出错，更载数据出错
EXIT_CODE_124=124      # 更新数据库操作出错，执行结果出错
EXIT_CODE_125=125      # 更新数据库操作出错，执行过程出错
EXIT_CODE_126=126      # IP变化，执行撤机操作出错
# 打印操作结果，并返回操作码
do_exit()
{
	ExitCode=$1
	case ${ExitCode} in
		0) echo "操作成功" ;;
		1) echo "用户目录下没有.erlang.cookie文件，不可以在这台服务器启动脚本" ;;
		2) echo "Erlang 版本出错，请检查并联系开发人员" ;;
		3) echo "配置文件xxx_yyy_zzz_common.config不存在，无法启动" ;;
		4) echo "没有代码ebin目录，无法启动" ;;
		5) echo "没有代码config目录，无法启动" ;;
		6) echo "远程调用游戏节点执行命令出错，没有参数" ;;
        7) echo "服务已经启动，启动失败" ;;
        8) echo "服务不存在，停止失败" ;;
        9) echo "当前服务正在运行，不可以执行此方式的更新" ;;
        10) echo "取消脚本执行" ;;
        11) echo "没有找到合服的数据，无法执行" ;;
		100) echo "表示参数出错，无法执行" ;;
		101) echo "节点参数出错" ;;
		102) echo "执行的动作参数出错" ;;
		103) echo "此命令无法执行" ;;
		104) echo "远程调用游戏节点执行命令出错" ;;
        110) echo "服务正在运行无法启动" ;;
        111) echo "数据库schema.DAT加载失败" ;;
        112) echo "数据表信息出错" ;;
        113) echo "数据表节点信息出错" ;;
        114) echo "master_host 配置出错" ;;
        115) echo "erlang_web_port 配置出错" ;;
        116) echo "erlang_web_port 程序无法监听此端口" ;;
        117) echo "gateway 配置出错" ;;
        118) echo "gateway 程序无法监听此端口" ;;
        119) echo "日志节点无法连通" ;;
        120) echo "日志数据库配置出现重复配置" ;;
        121) echo "日志数据库连接失败" ;;
        122) echo "更新数据库操作出错，当前没有数据库文件" ;;
        124) echo "更新数据库操作出错，更载数据出错" ;;
        125) echo "更新数据库操作出错，执行结果出错" ;;
        126) echo "IP变化，执行撤机操作出错" ;;
		*) echo "未知错误Exit Reason=${ExitCode}" ;;
	esac
	echo $1
	exit 0
}

# 检查 erlang.cookie
if [ ! -f ~/.erlang.cookie ] ; then
	do_exit ${EXIT_CODE_1} 
fi
ERLANG_COOKIE=`cat ~/.erlang.cookie`

## 检查ERLANG 版本
ERL=erl
TARGET_ERLANG="17"
OTP_RELEASE=`erl -noshell -eval 'R = erlang:system_info(otp_release), io:format("~s", [R])' -s erlang halt`
if [ "${OTP_RELEASE}" = "${TARGET_ERLANG}" ] ; then
	ERL=erl
else
	do_exit ${EXIT_CODE_2}
fi

# 服务端目录
SERVER_DIR=""
gen_server_dir()
{
	SERVER_DIR=$1
}

# 配置文件 
SETTING_FILE=""
gen_setting_file()
{
	SETTING_FILE=$1
}

# 日志目录
LOG_DIR=""
gen_log_dir()
{
	LOG_DIR=$1
}

# 初始化启动状态文件
BOOT_STATUS_FILE=""
gen_boot_status_file()
{
    BOOT_STATUS_FILE=$1
}


# 初始化game_name,agent_name,server_name,master_host
GAME_NAME=""
AGENT_NAME=""
SERVER_NAME=""
MASTER_HOST=""
gen_config_param()
{
	GAME_NAME=$1
	AGENT_NAME=$2
	SERVER_NAME=$3
	MASTER_HOST=$4
}

# Database Dir
DATABASE_DIR=""
gen_database_dir()
{
	DATABASE_DIR=$1
	if [ ! -d ${DATABASE_DIR} ] ; then
		mkdir -p ${DATABASE_DIR}
	fi
	if [ ! -d ${DATABASE_DIR}/backup ] ; then
		mkdir -p ${DATABASE_DIR}/backup
	fi
}

# Mnesia Database Dir
MNESIA_DATABASE_DIR=""
gen_mnesia_database_dir()
{
	MNESIA_DATABASE_DIR=$1
}

# 游戏节点名称
# $1=AgentName,$2=ServerName,$3=MasterHost
GAME_NODE_NAME=""
gen_game_node_name()
{
	GAME_NODE_NAME="$1_$2_$3@$4"
}

# 游戏日志服务节点名称
LOGGER_NODE_NAME=""
gen_logger_node_name()
{
	LOGGER_NODE_NAME="$1_$2_$3@$4"
}

# 获取ebin目录
# 参数：
#    ServerEBinDir : ebin根据目录
EBIN_PA=""
gen_server_ebin_path(){
    EBIN_PA=${EBIN_PA}" -pa "$1
    for file in ` ls $1 `
    do
        if [ -d $1"/"$file ] ; then
            gen_server_ebin_path $1"/"$file
        fi
    done
}

# sasl param  -sasl sasl_error_logger {file,"xxx_sasl.log"}
# $1:日志目录 $2:节点名称
SASL_PARAM=""
gen_sasl_param()
{
    SASL_PARAM="-sasl sasl_error_logger {file,\"$1/$2_sasl.log\"} "
}
# erl_crash_dump
# $1:日志目录 $2:节点名称
ERL_CRASH_DUMP_PARAM=""
gen_erl_crash_dump_param()
{
    DataTime=`date "+%Y%m%d_%H%M%S"`
    ERL_CRASH_DUMP_PARAM="-env ERL_CRASH_DUMP $1/$2_erl_crash_dump_${DataTime}.dump"
}
# mnesia dir
# $1=MnesiaDatabaseDir
MNESIA_PARAM=""
gen_mnesia_param()
{
    # -mnesia dump_log_time_threshold 300000 定时dump的默认的时间间隔为3分钟
    # -mnesia dump_log_write_threshold 5000 一定数量的日志记录后触发
    # -mnesia dc_dump_limit Num DCL save to DCD
    # 当sizeof(DCD)/sizeof(DCL)小于指定的阈值时，把表中的内容全部存储到DCD文件中，否则直接写到DCL文件中，默认的阈值大小为4，对于存储类型为disc_only_copies的表不做任何处理
	MNESIA_PARAM="-mnesia dir \"$1\" -mnesia dump_log_write_threshold 100000 -mnesia no_table_loaders 100"
}

# 扩展参数
# $1=ServerDir,$2=SettingFile,$3=LogDir,$4=MnesiaDatabaseDir,$5=ServerDataDir,$6=DatabaseDir
EXT_PARAM=""
gen_ext_param()
{
	EXT_PARAM="-server_dir $1 -setting_file $2 -log_dir $3 -mnesia_dir $4 -server_data_dir $5 -database_dir $6 -setcookie ${ERLANG_COOKIE}"
}

# 初始化服务端数据目标
SERVER_DATA_DIR=""
gen_server_data_dir()
{
	SERVER_DATA_DIR=$1
	if [ ! -d ${SERVER_DATA_DIR} ] ; then
		mkdir -p ${SERVER_DATA_DIR}
	fi
}

# 初始化脚本执行日志
SHELL_LOG_FILE=""
gen_shell_log_file()
{
	SHELL_LOG_FILE=$1
	if [ ! -f ${SHELL_LOG_FILE} ] ; then
		echo "" > ${SHELL_LOG_FILE}
	fi
}

# 脚本执行日志
shell_log()
{
	LogTime=`date "+%Y-%m-%d %H:%M:%S"`
	echo "${LogTime} $1" >> ${SHELL_LOG_FILE}
}


## 启动游戏
do_start_server()
{
    # 是否需要快速启动
    IsQuick=""
	if [ "$1" != "" ] ; then
		IsQuick=$1
	fi
    
    # 判断服务是不是已经启动
    IsStarted=`ps -ef|grep ${GAME_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    if [ "${IsStarted}" != "" ] ; then
        shell_log "${GAME_NODE_NAME} server pid=${IsStarted}"
        do_exit ${EXIT_CODE_7}
    fi
    
    if [ "${IsQuick}" != "q" ] ; then
        # 检查服务是否可以正常启动
        ExecNode="exec_${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}@${MASTER_HOST}"
        RUN_COMMAND="${ERL} -name ${ExecNode} -hidden -smp disable -noshell ${EBIN_PA} ${EXT_PARAM} \
-run main_exec start -run erlang halt -extra ${GAME_NODE_NAME} verify_server"
        shell_log "${RUN_COMMAND}"
        RS=`${RUN_COMMAND} | grep "EXIT_CODE:"`
        shell_log "exec result=${RS}"
        ExitCode=${RS#*EXIT_CODE:}
        shell_log "Exit Code=${ExitCode}"
        if [ "${ExitCode}" != "0" ] ; then
            do_exit ${ExitCode}
        fi
    fi
    
	gen_sasl_param ${LOG_DIR} ${GAME_NODE_NAME}
	gen_erl_crash_dump_param ${LOG_DIR} ${GAME_NODE_NAME}
	
    # RUN_COMMAND="${ERL} +h 10240 +K true -detached -noinput -env ERL_MAX_PORTS 250000 +K true \
    RUN_COMMAND="${ERL} +h 10240 +K true -detached -env ERL_MAX_PORTS 250000 +K true \
-s mgeew -name ${GAME_NODE_NAME} ${EBIN_PA} \
-env ERL_MAX_ETS_TABLES 500000 +P 250000 \
${MNESIA_PARAM} ${ERL_CRASH_DUMP_PARAM} ${SASL_PARAM} ${EXT_PARAM} "
	shell_log "${RUN_COMMAND}"
    echo "" > ${BOOT_STATUS_FILE}
    ${RUN_COMMAND}
    STATUS_CODE=1
    while [[ "${STATUS_CODE}" != "0" && "${STATUS_CODE}" != "99" ]] 
    do
        sleep 0.005
        STATUS_CODE_TMP=`cat ${BOOT_STATUS_FILE}`
        if [[ "${STATUS_CODE_TMP}" != "" && "${STATUS_CODE_TMP}" != "${STATUS_CODE}" ]] ; then
            STATUS_CODE=${STATUS_CODE_TMP}
            do_status ${STATUS_CODE}
        fi
    done
    echo ${STATUS_CODE}
    exit 0
}
# 打印服务器启动状态
do_status()
{
	StatusCode=$1
    StatusDesc=""
	case ${StatusCode} in
		0) StatusDesc="服务启动成功" ;;
		1) StatusDesc="开启启动服务" ;;
		2) StatusDesc="数据库服务启动成功" ;;
		3) StatusDesc="聊天服务启动成功" ;;
		4) StatusDesc="游戏世界服务启动成功" ;;
		5) StatusDesc="游戏地图服务启动成功" ;;
		6) StatusDesc="游戏端口服务启动成功" ;;
        7) StatusDesc="Mochiweb 服务启动成功" ;;
        8) StatusDesc="日志服务启动成功" ;;
        9) StatusDesc="登录服务启动成功" ;;
        10) StatusDesc="初始化地图失败" ;;
        11) StatusDesc="初始化数据成功" ;;
        12) StatusDesc="EMysql服务启动成功" ;;
        99) StatusDesc="服务启动异常，启动失败" ;;
		*) StatusDesc="未知状态StatusCode=${StatusCode}" ;;
	esac
    shell_log "${StatusDesc}"
    echo "${StatusDesc}"
}

## 停止游戏
do_stop_server()
{
    # 判断服务是否存在
    IsStarted=`ps -ef|grep ${GAME_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    shell_log "${GAME_NODE_NAME} server pid=${IsStarted}"
    if [ "${IsStarted}" == "" ] ; then
        do_exit ${EXIT_CODE_8}
    fi
	do_main_exec ${GAME_NODE_NAME} stop
}

## 进入游戏节点【一般用于查看游戏数据，开发者查看问题使用】
do_debug_server()
{
	RUN_COMMAND="${ERL} -name $1_debug_${AGENT_NAME}_${SERVER_NAME}@${MASTER_HOST} -hidden -smp disable -remsh ${GAME_NODE_NAME} ${EBIN_PA} ${EXT_PARAM}"
	shell_log "${RUN_COMMAND}"
	${RUN_COMMAND}
}

## live模式启动游戏【以Live模式启动服务，更方便调测问题】
do_live_server()
{
	gen_sasl_param ${LOG_DIR} ${GAME_NODE_NAME}
	gen_erl_crash_dump_param ${LOG_DIR} ${GAME_NODE_NAME}
	
    RUN_COMMAND="${ERL} +h 10240 +K true -env ERL_MAX_PORTS 250000 +K true \
-s mgeew -name ${GAME_NODE_NAME} ${EBIN_PA} \
-env ERL_MAX_ETS_TABLES 500000 +P 250000 \
${MNESIA_PARAM} ${ERL_CRASH_DUMP_PARAM} ${SASL_PARAM} ${EXT_PARAM} "
	shell_log "${RUN_COMMAND}"
	${RUN_COMMAND}
}

## 踢服务器玩家下线
do_kick_role()
{
	do_main_exec ${GAME_NODE_NAME} kick_role
}

## 更新游戏数据库操作
do_update_database()
{
    # 当前服务正在运行，不可以执行此方式的更新
    IsStarted=`ps -ef|grep ${GAME_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    if [ "${IsStarted}" != "" ] ; then
        shell_log "${GAME_NODE_NAME} server pid=${IsStarted}"
        do_exit ${EXIT_CODE_9}
    fi
    # 更新游戏数据库操作，必须是以游戏同名的运行节点启动
    RUN_COMMAND="${ERL} +h 10240 +K true -hidden -smp disable -noshell -env ERL_MAX_PORTS 250000 +K true \
-name ${GAME_NODE_NAME} ${EBIN_PA} \
-env ERL_MAX_ETS_TABLES 500000 +P 250000 \
${MNESIA_PARAM} ${ERL_CRASH_DUMP_PARAM} ${SASL_PARAM} ${EXT_PARAM} \
-run main_exec start -run erlang halt -extra ${GAME_NODE_NAME} update_database $*"
    shell_log "${RUN_COMMAND}"
    RS=`${RUN_COMMAND} | grep "EXIT_CODE:"`
    shell_log "exec result=${RS}"
    ExitCode=${RS#*EXIT_CODE:}
    shell_log "Exit Code=${ExitCode}"
    do_exit ${ExitCode}
}

## 离线撤机操作脚本，主要是更新Mnesia数据库的schema结构
do_lixiancheji()
{
    # 当前服务正在运行，不可以执行此方式的更新
    IsStarted=`ps -ef|grep ${GAME_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    if [ "${IsStarted}" != "" ] ; then
        shell_log "${GAME_NODE_NAME} server pid=${IsStarted}"
        do_exit ${EXIT_CODE_9}
    fi
    LixianchejiDir=${DATABASE_DIR}/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}_lixiancheji
    # 更新游戏数据库操作，必须是以游戏同名的运行节点启动
    RUN_COMMAND="${ERL} +h 10240 +K true -hidden -smp disable -noshell -env ERL_MAX_PORTS 250000 +K true \
-name ${GAME_NODE_NAME} ${EBIN_PA} \
-env ERL_MAX_ETS_TABLES 500000 +P 250000 \
-mnesia dir \"${LixianchejiDir}\" ${EXT_PARAM} \
-run main_exec start -run erlang halt -extra ${GAME_NODE_NAME} lixiancheji"
    shell_log "${RUN_COMMAND}"
    RS=`${RUN_COMMAND} | grep "EXIT_CODE:"`
    shell_log "exec result=${RS}"
    ExitCode=${RS#*EXIT_CODE:}
    shell_log "Exit Code=${ExitCode}"
    do_exit ${ExitCode}
}

## 启动游戏日志服务节点
do_start_logger_server()
{
    # 是否需要快速启动
    IsQuick=""
	if [ "$1" != "" ] ; then
		IsQuick=$1
	fi
    # 判断服务是不是已经启动
    IsStarted=`ps -ef|grep ${LOGGER_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    if [ "${IsStarted}" != "" ] ; then
        shell_log "${LOGGER_NODE_NAME} server pid=${IsStarted}"
        do_exit ${EXIT_CODE_7}
    fi
    if [ "${IsQuick}" != "q" ] ; then
        # 检查日志节点是否可以正常启动
        ExecNode="exec_logger_${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}@${MASTER_HOST}"
        RUN_COMMAND="${ERL} -name ${ExecNode} -hidden -smp disable -noshell ${EBIN_PA} ${EXT_PARAM} \
-run main_exec start -run erlang halt -extra ${LOGGER_NODE_NAME} verify_logger_server"
        shell_log "${RUN_COMMAND}"
        RS=`${RUN_COMMAND} | grep "EXIT_CODE:"`
        shell_log "exec result=${RS}"
        ExitCode=${RS#*EXIT_CODE:}
        shell_log "Exit Code=${ExitCode}"
        if [ "${ExitCode}" != "0" ] ; then
            do_exit ${ExitCode}
        fi
    fi
    
	gen_sasl_param ${LOG_DIR} ${LOGGER_NODE_NAME}
	gen_erl_crash_dump_param ${LOG_DIR} ${LOGGER_NODE_NAME}
	
    RUN_COMMAND="${ERL} +h 10240 +K true -detached -noinput -hidden -env ERL_MAX_PORTS 250000 -s logger \
-name ${LOGGER_NODE_NAME} ${EBIN_PA} -env ERL_MAX_ETS_TABLES 500000 +P 250000 \
${ERL_CRASH_DUMP_PARAM} ${SASL_PARAM} ${EXT_PARAM} "
 	shell_log "${RUN_COMMAND}"
    echo "" > ${BOOT_STATUS_FILE}
	${RUN_COMMAND}
    STATUS_CODE=1
    while [[ "${STATUS_CODE}" != "0" && "${STATUS_CODE}" != "99" ]] 
    do
        sleep 0.001
        STATUS_CODE_TMP=`cat ${BOOT_STATUS_FILE}`
        if [[ "${STATUS_CODE_TMP}" != "" && "${STATUS_CODE_TMP}" != "${STATUS_CODE}" ]] ; then
            STATUS_CODE=${STATUS_CODE_TMP}
            do_status ${STATUS_CODE}
        fi
    done
    echo ${STATUS_CODE}
    exit 0
}
## 停止游戏日志服务节点
do_stop_logger_server()
{
    # 判断服务是否存在
    IsStarted=`ps -ef|grep ${LOGGER_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    shell_log "${LOGGER_NODE_NAME} server pid=${IsStarted}"
    if [ "${IsStarted}" == "" ] ; then
        do_exit ${EXIT_CODE_8}
    fi
	do_main_exec ${LOGGER_NODE_NAME} stop_logger
}
## 进入游戏日志节点【一般用于查看日志数据，日志入库功能运行状态，开发都使用】
do_debug_logger_server()
{
	RUN_COMMAND="${ERL} -name $1_debug_${AGENT_NAME}_${SERVER_NAME}@${MASTER_HOST} -hidden -smp disable -remsh ${LOGGER_NODE_NAME} ${EBIN_PA} ${EXT_PARAM}"
	shell_log "${RUN_COMMAND}"
	${RUN_COMMAND}
}
## live模式启动游戏日志服务节点【以Live模式启动服务，更方便调测问题】
do_live_logger_server()
{
	gen_sasl_param ${LOG_DIR} ${LOGGER_NODE_NAME}
	gen_erl_crash_dump_param ${LOG_DIR} ${LOGGER_NODE_NAME}
	
    RUN_COMMAND="${ERL} -smp disable +h 10240 +K true -hidden -env ERL_MAX_PORTS 250000 \
-s logger -name ${LOGGER_NODE_NAME} ${EBIN_PA} -env ERL_MAX_ETS_TABLES 500000 +P 250000 \
${ERL_CRASH_DUMP_PARAM} ${SASL_PARAM} ${EXT_PARAM} "
 	shell_log "${RUN_COMMAND}"
	${RUN_COMMAND}
}
## 备份游戏Mnesia数据库
do_mnesia_backup()
{
	do_main_exec ${GAME_NODE_NAME} mnesia_backup
}
## 热更新服务器beam文件
## 参数 ModuleName | ModuleName ModuleName ModuleName ModuleName
do_hot_update_beam()
{
	do_main_exec ${GAME_NODE_NAME} hot_update_beam $*
}
## 热更新服务器config文件
## 参数config文件名，不需要带后缀
## 例如: common | common title etc
do_hot_update_config()
{
	do_main_exec ${GAME_NODE_NAME} hot_update_config $*
}
## 游戏服务器中执行模块方法
## 参数：ModuleName MethodName ArgA ArgsB
## 例如：common_config get_opened_days
##      common_misc get_role_gateway_process_name 100000100000001
do_exec_func()
{
	do_main_exec ${GAME_NODE_NAME} exec_fun $*
}

## 发送命令到游戏服执行
## Command [ArgsA,ArgsB,...]
do_main_exec()
{
	if [ $# -eq 0 ] ; then
		shell_log "没有命令参数无法执行脚本"
		do_exit ${EXIT_CODE_6}
	fi
	RpcNode=$1
	shift
	ExecParam=$*
	ExecNode="exec_${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}@${MASTER_HOST}"
	RUN_COMMAND="${ERL} -name ${ExecNode} -hidden -smp disable -noshell \
${EBIN_PA} ${EXT_PARAM} \
-run main_exec start -run erlang halt -extra ${RpcNode} ${ExecParam}"
	shell_log "${RUN_COMMAND}"
	## op_code 错误码:0:表示执行成功，
	##               100:表示参数出错，无法执行
	##               101:节点参数出错
	##               102:执行的动作参数出错
	##               103:此命令无法执行
	##               104:远程调用游戏节点执行命令出错
    RS=`${RUN_COMMAND} | grep "EXIT_CODE:"`
	shell_log "exec result=${RS}"
	shell_log ""
    ExitCode=${RS#*EXIT_CODE:}
	shell_log "Exit Code=${ExitCode}"
	do_exit ${ExitCode}
}

## 生成合服数据【合服通过此操作获取合服数据，此操作同时执行删号操作】
gen_merge_data()
{
    # 当前服务正在运行，不可以执行此方法生成合服数据
    IsStarted=`ps -ef|grep ${GAME_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    if [ "${IsStarted}" != "" ] ; then
        shell_log "${GAME_NODE_NAME} server pid=${IsStarted}"
        do_exit ${EXIT_CODE_9}
    fi
    Dir=${DATABASE_DIR}/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}_merge
    # 更新游戏数据库操作，必须是以游戏同名的运行节点启动
    RUN_COMMAND="${ERL} +h 10240 +K true -hidden -smp disable -noshell -env ERL_MAX_PORTS 250000 \
-name ${GAME_NODE_NAME} ${EBIN_PA} ${MNESIA_PARAM} ${EXT_PARAM} \
-run main_exec start -run erlang halt -extra ${GAME_NODE_NAME} gen_merge_data"
    shell_log "${RUN_COMMAND}"
    RS=`${RUN_COMMAND} | grep "EXIT_CODE:"`
    shell_log "exec result=${RS}"
    ExitCode=${RS#*EXIT_CODE:}
    shell_log "Exit Code=${ExitCode}"
    do_exit ${ExitCode}
}
## 执行合服操作
do_merge()
{
    # 当前服务正在运行，不可以执行此方法生成合服数据
    IsStarted=`ps -ef|grep ${GAME_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    if [ "${IsStarted}" != "" ] ; then
        shell_log "${GAME_NODE_NAME} server pid=${IsStarted}"
        do_exit ${EXIT_CODE_9} 
    fi
	MegerDatabaseDir=${DATABASE_DIR}/merge_${AGENT_NAME}_${GAME_NAME}_${SERVER_NAME}
    # 判断当前合服操作的数据库是否已经有数据了，提示并删除
    if [ -d ${MegerDatabaseDir} ] ; then
        echo "存在已经合服的数据，是否清除并重新执行合服操作[y]"
        read ANS
        case $ANS in 
        y|Y|yes|Yes) 
            rm -rf ${MegerDatabaseDir}
            do_merge_exec
        ;;
        *) 
            echo "此次合服操作被用户取消"
            do_exit ${EXIT_CODE_10}
        ;;
        esac
    else
        do_merge_exec
    fi
}
## 执行合服操作
do_merge_exec()
{
    RUN_COMMAND="${ERL} +K true +P 250000 +h 10240 -smp disable -noshell \
-name ${GAME_NODE_NAME} -env ERL_MAX_ETS_TABLES 500000  \
-mnesia dump_log_write_threshold 100000 -mnesia no_table_loaders 100 -mnesia dir \"${MegerDatabaseDir}/\"
${EBIN_PA} ${EXT_PARAM} -run merge start -run erlang halt"
    shell_log "${RUN_COMMAND}"
    RS=`${RUN_COMMAND} | grep "EXIT_CODE:"`
    shell_log "exec result=${RS}"
    ExitCode=${RS#*EXIT_CODE:}
    shell_log "Exit Code=${ExitCode}"
    do_exit ${ExitCode}
}
## 发布，部署合服的数据到目标数据库
do_merge_deploy()
{
    IsStarted=`ps -ef|grep ${GAME_NODE_NAME} | grep -v 'grep' | awk '{print $2}'`
    if [ "${IsStarted}" != "" ] ; then
        shell_log "${GAME_NODE_NAME} server pid=${IsStarted}"
        do_exit ${EXIT_CODE_9} 
    fi
    MegerDatabaseDir=${DATABASE_DIR}/merge_${AGENT_NAME}_${GAME_NAME}_${SERVER_NAME}
    if [ -d ${MegerDatabaseDir} ] ; then
        rm -rf ${MNESIA_DATABASE_DIR}
        \cp -rf ${MegerDatabaseDir} ${MNESIA_DATABASE_DIR}
        do_exit ${EXIT_CODE_0}
    else
        do_exit ${EXIT_CODE_11}
    fi
}

## 脚本入口
## 参数:
## Command:命令
## SettingFile:配置文件
## ServerDir:服务端代码目录
do_main()
{   
	CMD=$1
	shift
	SettingFile=$1
	shift
	ServerDir=$1
	shift
	
	if [ ! -f ${SettingFile} ] ; then
		do_exit ${EXIT_CODE_3}
	fi
	# 初始化 setting/common.config
	gen_setting_file ${SettingFile}
	if [ ! -d ${ServerDir}/ebin ] ; then
		do_exit ${EXIT_CODE_4}
	fi
	if [ ! -d ${ServerDir}/config ] ; then
		do_exit ${EXIT_CODE_5}
	fi
	# 初始化Server Dir
	gen_server_dir ${ServerDir}
	
	# 根据配置文件setting.config获取 game_name、agent_name、server_name
	GameName=`grep game_name ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
	AgentName=`grep agent_name ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
	ServerName=`grep server_name ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
	MasterHost=`grep master_host ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
	
	# 初始化变量
	gen_config_param ${GameName} ${AgentName} ${ServerName} ${MasterHost}
	
	# 日志目录
	LogDir=/data/logs/${AGENT_NAME}_${SERVER_NAME}
	if [ ! -d ${LogDir} ] ; then
		mkdir -p ${LogDir}
	fi
	# 初始化日志目录
	gen_log_dir ${LogDir}
	
    # 初始化启动状态文件
    BootStatusFile=${LOG_DIR}/boot_status.log
	gen_boot_status_file ${BootStatusFile}
    
	DatabaseDir=/data/database
	gen_database_dir ${DatabaseDir}
	
	# Mnesia 游戏数据库目录
	MnesiaDatabaseDir=${DATABASE_DIR}/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}
	if [ ! -d ${MnesiaDatabaseDir} ] ; then
		mkdir -p ${MnesiaDatabaseDir}
	fi
	# 初始化数据库目录
	gen_mnesia_database_dir ${MnesiaDatabaseDir}
	
	# 初始化游戏节点
	gen_game_node_name ${GAME_NAME} ${AGENT_NAME} ${SERVER_NAME} ${MASTER_HOST}
	# 初始化游戏日志节点名称
	gen_logger_node_name ${GAME_NAME} ${AGENT_NAME} ${SERVER_NAME} ${MASTER_HOST}
	
	# Mnesia 数据库参数
	gen_mnesia_param ${MNESIA_DATABASE_DIR}
	
	# 初始化EBIN PA
	gen_server_ebin_path ${SERVER_DIR}/ebin
	
	# 初始化服务目录
	ServerDataDir=/data/games/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}/server
	gen_server_data_dir ${ServerDataDir}
	
	# 初始化扩展参数
	gen_ext_param ${SERVER_DIR} ${SETTING_FILE} ${LOG_DIR} ${MNESIA_DATABASE_DIR} ${SERVER_DATA_DIR} ${DATABASE_DIR}
	
	# 初始化脚本执行日志
	gen_shell_log_file ${LOG_DIR}/exec_shell_script.log
	
	# 记录日志
	shell_log ""
	shell_log ""
	shell_log "Command=${CMD}"
	shell_log "SettingFile=${SettingFile}"
	shell_log "ServerDir=${ServerDir}"
	shell_log ""
	
	case ${CMD} in
		start) do_start_server $*;;
		stop) do_stop_server ;;
		debug) do_debug_server $*;;
		live) do_live_server ;;
		kick_role) do_kick_role ;;
        updb) do_update_database $*;;
        lixiancheji) do_lixiancheji ;;
        gen_merge_data) gen_merge_data ;;
		start_logger) do_start_logger_server $*;;
		stop_logger) do_stop_logger_server ;;
		debug_logger) do_debug_logger_server $*;;
		live_logger) do_live_logger_server ;;
		backup) do_mnesia_backup ;;
		merge) do_merge ;;
        merge_deploy) do_merge_deploy ;;
		upbeam) do_hot_update_beam $*;;
		upconf) do_hot_update_config $*;;
		func) do_exec_func $*;;
		*) do_help ;;
	esac
}
## 脚本帮助信息
do_help()
{
	echo "    run.sh 使用说明："
	echo "    基本语法: run.sh Command SettingFile ServerDir [Option]"
	echo "        SettingFile：服务器配置文件"
	echo "        ServerDir：服务器代码目录"
	echo "        Command：命令说明："
	echo "            help                                 显示脚本帮助信息"
	echo "            start                                启动游戏"
	echo "            stop                                 停止游戏"
	echo "            debug                                进入游戏节点【一般用于查看游戏数据，开发者查看问题使用】"
	echo "            live                                 live模式启动游戏【以Live模式启动，更方便调试问题】"
	echo "            kick_role                            踢服务器玩家下线"
    echo "            updb                                 数据库更新操作【停服之后操作】"
    echo "            lixiancheji                          服务器ip变化需要执行此操作之后才能正常启动服务【离线撤机脚本】"
    echo "            gen_merge_data                       生成合服数据【合服通过此操作获取合服数据，此操作同时执行删号操作】"
	echo "            start_logger                         启动游戏日志服务"
	echo "            stop_logger                          停止游戏日志服务"
	echo "            debug_logger                         进入游戏日志服务节点【一般用于查看游戏数据，开发者查看问题使用】"
	echo "            live_logger                          live模式启动游戏日志服务【以Live模式启动，更方便调试问题】"
	echo "            backup                               备份游戏Mnesia数据库"
	echo "            merge                                合服操作"
    echo "            merge_deploy[merged]                 合服操作完成，部署合服的数据"
	echo "            upbeam                               热更新服务器beam文件"
	echo "            upconf                               热更新服务器config文件"
	echo "            func                                 游戏服务器中执行模块方法"
}

## 脚本入口
if [ $# -eq 0 ]; then
	do_help
	exit 0
fi

## 脚本入口主函数
Command=$1
shift
case ${Command} in
	help) do_help ;;
	start) do_main start $*;;
	stop) do_main stop $*;;
	debug) do_main debug $*;;
	live) do_main live $*;;
	kick_role) do_main kick_role $*;;
    updb) do_main updb $*;;
    lixiancheji) do_main lixiancheji $*;;
    gen_merge_data) do_main gen_merge_data $*;;
	start_logger) do_main start_logger $*;;
	stop_logger) do_main stop_logger $*;;
	debug_logger) do_main debug_logger $*;;
	live_logger) do_main live_logger $*;;
	backup) do_main backup $*;;
	merge) do_main merge $*;;
    merged) do_main merge_deploy $*;;
    merge_deploy) do_main merge_deploy $*;;
	upbeam) do_main upbeam $*;;
	upconf) do_main upconf $*;;
	func) do_main func $*;;
	*) do_help ;;
esac
