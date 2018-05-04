#!/bin/bash
#---------------------------------------------------------------------
# author:  <caochuncheng2002@gmail.com>
# desc: 开发脚本，管理项目编译，启动等操作，主要是给开发人员使用
# create_date: 2015-12-15
#---------------------------------------------------------------------

## 设置参数
ulimit -c unlimited
ulimit -SHn 51200

## 获取脚本执行目录
here=`which "$0" 2>/dev/null || echo .`
base="`dirname $here`"
SHELL_DIR=`(cd "$base"; echo $PWD)`

## 打印日志
do_log()
{
	LogTime=`date "+%Y-%m-%d %H:%M:%S"`
	echo "${LogTime} $1"
}

## 检查ERLANG 版本
ERL=erl
ERLC=erlc
TARGET_ERLANG="17"
OTP_RELEASE=`erl -noshell -eval 'R = erlang:system_info(otp_release), io:format("~s", [R])' -s erlang halt`
if [ "${OTP_RELEASE}" = "${TARGET_ERLANG}" ] ; then
	ERL=erl
	ERLC=erlc
else
	echo "Erlang 版本出错，请检查并联系开发人员"
	exit 0
fi

SETTING_FILE=${SHELL_DIR}/setting/common.config
# 根据配置文件setting.config获取 game_name、agent_name、server_name
GAME_NAME=`grep game_name ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
AGENT_NAME=`grep agent_name ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
SERVER_NAME=`grep server_name ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
MASTER_HOST=`grep master_host ${SETTING_FILE} | awk -F"," '{print $2}' | awk -F\" '{print $2}'`

## 服务器编码目标代码
SERVER_DIR="/data/games/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}/server"
SERVER_EBIN_DIR=${SERVER_DIR}/ebin
SERVER_CONFIG_DIR=${SERVER_DIR}/config

## 代码目录
## 核心代码
SRC_CORE_DIRS=(
	"db"
    "gateway"
    "log"
)
## 逻辑代码
SRC_DIRS=(
    "common"
    "behavior"
    "chat"
    "map"
    "world"
    "mgeeweb"
    "merge"
    "update"
)
## 是否有核心代码 0无 1有
IS_CORE_CODE=0
if [ -d ${SHELL_DIR}/app/game/db ] ; then
	IS_CORE_CODE=1
	SRC_DIRS=(
	    "common"
	    "behavior"
	    "chat"
	    "db"
	    "gateway"
	    "map"
	    "world"
	    "mgeeweb"
	    "merge"
	    "update"
	    "log"
	)
fi

## 复制项目文件
do_copy()
{
    do_log "拷贝配置文件到目标目录开始>>>>>>======="
	rm -rf ${SERVER_CONFIG_DIR}
	mkdir -p ${SERVER_CONFIG_DIR}
	if [ ! -d ${SERVER_EBIN_DIR}/library ] ; then
		mkdir -p ${SERVER_EBIN_DIR}/library
	fi
	if [ ! -d ${SERVER_EBIN_DIR}/mochiweb ] ; then
		mkdir -p ${SERVER_EBIN_DIR}/mochiweb
	fi
	\cp -rf ${SHELL_DIR}/ebin/library  $SERVER_EBIN_DIR/
	\cp -rf ${SHELL_DIR}/ebin/mochiweb $SERVER_EBIN_DIR/
	
	## 没有核心代码需要
	if [ ${IS_CORE_CODE} == 0 ] ; then
		for srccore in ${SRC_CORE_DIRS[@]} 
		do
			if [ ! -d ${SHELL_DIR}/ebin/${srccore} ] ; then
				do_log "缺少核心代码${srccore}"
				exit 0
			fi
			rm -rf ${SERVER_EBIN_DIR}/${srccore}
			\cp -rf ${SHELL_DIR}/ebin/${srccore} ${SERVER_EBIN_DIR}/${srccore}
		done
	fi
	## 复制配置文件 
	\cp -rf ${SHELL_DIR}/config/app/* $SERVER_EBIN_DIR/
	\cp -rf ${SHELL_DIR}/config ${SERVER_DIR}/
	## 清除不需要的配置文件 
	rm -rf ${SERVER_CONFIG_DIR}/app
	rm -rf ${SERVER_CONFIG_DIR}/base_data
	rm -rf ${SERVER_CONFIG_DIR}/include
	rm -rf ${SERVER_CONFIG_DIR}/src
	## 复制项目配置文件和运行脚本
	\cp -rf ${SHELL_DIR}/setting ${SERVER_DIR}/
	\cp -rf ${SHELL_DIR}/dev.sh ${SERVER_DIR}/
	\cp -rf ${SHELL_DIR}/run.sh ${SERVER_DIR}/
	
	## 删除所有svn文件
	find ${SERVER_DIR} -type d -name "*.svn*" | xargs rm -rf
	
	do_log "拷贝配置文件到目标目录结束>>>>>>>>>>>>>"
}
## 编译代码
## sh dev.sh make 
do_make()
{
	do_log "编译代码开始>>>>>>======="
	# 切换到脚本目录，生成基础数据
	cd ${SHELL_DIR}/script
	# 生成游戏前端与后端通信协议文件
	/usr/bin/php ${SHELL_DIR}/script/build_proto_erlang.php
	/usr/bin/php ${SHELL_DIR}/script/build_mm_map.php server
	# 生成项目相关字典数据
	/usr/bin/php ${SHELL_DIR}/script/build_dict.php
	# 生成前端需要的配置文件
	sh make_front_end.sh
	
	# 是否重新生成配置，主要是任务数据和地图数据
	IS_RESET_GEN=0
	if [ "$1" = "gen" ] ; then
		IS_RESET_GEN=1
	fi
	if [ ${IS_RESET_GEN} = 1 ] ; then 
	       #生成任务配置数据
			do_log "生成任务配置数据开始>>>>>>=======" 
			cd ${SHELL_DIR}/script/serialize
			/usr/bin/php ${SHELL_DIR}/script/serialize/index.php mission
			cd ${SHELL_DIR}
			do_log "生成任务配置数据结束>>>>>>>>>>>>>" 
			#编译解释地图数据
			do_log "生成地图配置开始>>>>>>=======" 
			rm -rf ${SHELL_DIR}/config/src/map/cfg_mcm_*.erl
			cd ${SHELL_DIR}/app/game/map/src/mod
        	${ERLC} -I ${SHELL_DIR}/hrl -I ${SHELL_DIR}/config/include/ -I ${SHELL_DIR}/app/game/map/include/ -o ${SERVER_EBIN_DIR}/map mod_map_analyse.erl
        	${ERLC} -I ${SHELL_DIR}/hrl -I ${SHELL_DIR}/config/include/ -I ${SHELL_DIR}/app/game/map/include/ -o ${SERVER_EBIN_DIR}/map mod_map_slice.erl
        	${ERL} -pa ${SERVER_EBIN_DIR}/map -smp disable -noshell -s mod_map_analyse do_analyse -s erlang halt -map_dir "${SHELL_DIR}/config/base_data/map/" -cfg_dir "${SHELL_DIR}/config/src/map/"
        	do_log "生成地图配置结束>>>>>>>>>>>>>" 
	fi
	
	# 拷贝配置文件到目标目录
	do_copy
	
	Worker=1
	for src in ${SRC_DIRS[@]}
	do
		do_log ""
		do_log "编译${src}模块代码开始"
		if [ "${src}" = "update" ]; then
			cd ${SHELL_DIR}/update/ && make -j ${Worker} ERL_CMD=${ERL} ERLC_CMD=${ERLC}
		else
			cd ${SHELL_DIR}/app/game/${src}/ && make -j ${Worker} ERL_CMD=${ERL} ERLC_CMD=${ERLC}
		fi
		if [ "${src}" = "common" ]; then
			do_log '同时重新编译配置文件'
			cd ${SHELL_DIR}/script/ && bash make_config_beam.sh ${Worker} ${ERL}
		fi
		do_log "编译${src}模块代码结束"
	done
	## 如果有核心代码，需要更新ebin
	if [ ${IS_CORE_CODE} == 1 ] ; then
		for srccore in ${SRC_CORE_DIRS[@]} 
		do
			rm -rf ${SHELL_DIR}/ebin/${srccore}
			\cp -rf ${SERVER_EBIN_DIR}/${srccore} ${SHELL_DIR}/ebin/${srccore}
		done
	fi
	do_log "编译代码结束>>>>>>>>>>>>>"
}

## 清除
do_clean()
{
	ModName=$1
	if [ "${ModName}" == "all" ]; then
		rm -f ${SERVER_EBIN_DIR}/config/*
	fi
	for src in ${SRC_DIRS[@]}
	do
		if [ "${src}" != "update" ];then
			if [ "${ModName}" == "all" ]; then
				cd ${SHELL_DIR}/app/game/${src} && make clean
			else 
				if [ "${src}" == "${ModName}" ]; then
					cd ${SHELL_DIR}/app/game/${src} && make clean
				fi
			fi
		fi
	done
}

## erlang 静态分析
do_dialyzer()
{
    cd ${SHELL_DIR}
	DIALYZER_PLT="${SHELL_DIR}/.dialyzer_plt"
	if [ -f ${DIALYZER_PLT} ] ; then
		do_log "使用现有的 dialyzer_plt 文件:${DIALYZER_PLT}"
	else
		do_log "创建新 dialyzer_plt 文件:${DIALYZER_PLT}"
		dialyzer --build_plt --output_plt ${DIALYZER_PLT} --apps erts kernel stdlib crypto mnesia sasl common_test eunit reltool
	fi
	do_log "重新加上 debug 参数编译erl文件 开始 >>>>>>======="
	do_make_debug
	do_log "重新加上 debug 参数编译erl文件 结束 >>>>>>>>>>>>>"
	DIALYZER_EBINS=""
	for src in ${SRC_DIRS[@]}
	do
		if [ "$src" != "update" ];then
			DIALYZER_EBINS="${DIALYZER_EBINS} ${SERVER_EBIN_DIR}/${src}"
		fi
		if [ "$src" = "common" ]; then
			DIALYZER_EBINS="${DIALYZER_EBINS} ${SERVER_EBIN_DIR}/config"
		fi
	done
	do_log "静态分析 beam 开始 >>>>>>======="
	dialyzer --build_plt --output_plt ${DIALYZER_PLT} -Werror_handling -Wrace_conditions -Wno_return -Wno_unused -Wno_match -r ${DIALYZER_EBINS}
    do_log "静态分析 beam 结束 >>>>>>>>>>>>>"
}
## erlang分析编码方式
do_make_debug()
{
	for src in ${SRC_DIRS[@]}
	do
		if [ "${src}" = "update" ]; then
			cd ${SHELL_DIR}/update/ && make debug
		else
			cd ${SHELL_DIR}/app/game/${src}/ && make debug
		fi
		if [ "${src}" = "common" ]; then
			cd ${SHELL_DIR}/config/src/ && make debug
		fi
	done
}

## 编译操作函数入口
## sh dev.sh make ModName
## sh dev.sh make gen
do_main_make()
{
	if [ "$1" != "" ] ; then
        ModName=$1
    else
        ModName=""
    fi
    IS_MAKE_SUB_MODULE=0
    for src in ${SRC_DIRS[@]}
    do
    	if [ "${src}" = "${ModName}" ]; then
    		IS_MAKE_SUB_MODULE=1
    	fi
    done
	if [ ${IS_MAKE_SUB_MODULE} = 1 ] ; then
		if [ "${ModName}" = "update" ]; then
			cd ${SHELL_DIR}/update/ && make
		else
			cd ${SHELL_DIR}/app/game/${ModName}/ && make
		fi
	else
		do_make $*
	fi
}

## 清理操作
do_main_clean()
{
	if [ "$1" != "" ] ; then
        ModName=$1
    else
        ModName=""
    fi
	PARAM="all"
    for src in ${SRC_DIRS[@]}
    do
    	if [ "${src}" = "${ModName}" ]; then
    		PARAM=${ModName}
    	fi
    done
	do_clean ${PARAM}	
}

## 重新编译
do_rebuild()
{
	do_clean "all"
	do_make gen
}

## 脚本入口
## 参数:
## Command:命令
do_main()
{
	CMD=$1
	shift
	
	case ${CMD} in
		make) do_main_make $*;;
		rebuild) do_rebuild ;;
		clean) do_main_clean $*;;
		dialyzer) do_dialyzer ;;
		*) do_help ;;
	esac
}

## 运行脚本入口
do_main_run()
{
	CMD=$1
	shift
	RUN_SETTING_FILE=${SERVER_DIR}/setting/common.config
	sh ${SHELL_DIR}/run.sh ${CMD} ${RUN_SETTING_FILE} ${SERVER_DIR} $*
}

## 开发服务器部署一个游戏日志服务节点
do_deploy_logger()
{
	LOGGER_NODE_NAME=logger
	LOGGER_DIR="/data/games/${GAME_NAME}_${LOGGER_NODE_NAME}_S1"
	if [ "$1" != "" ] ; then
		LOGGER_NODE_NAME=$1
		LOGGER_DIR="/data/games/${GAME_NAME}_${LOGGER_NODE_NAME}"
	fi
	LOGGER_CONFIG_BACKUP_DIR=${LOGGER_DIR}/backup
	echo "部署目录为:${LOGGER_DIR}"
	echo "使用 sh mgectl deploy_logger xxx_xx 可修改部署目录"
	echo "是否将游戏日志服务部署到?[y]"
	read ANS
	case $ANS in    
	y|Y|yes|Yes) 
			if [ ! -d ${SERVER_DIR} ] ; then
				echo "没有服务代码${SERVER_DIR}，无法部署"
				exit 0
			fi
			if [ ! -d ${LOGGER_DIR} ] ; then
				mkdir -p ${LOGGER_DIR}
			fi
			if [ -f ${LOGGER_DIR}/server/setting/common.config ] ; then
				if [ ! -d ${LOGGER_CONFIG_BACKUP_DIR} ] ; then
					mkdir -p ${LOGGER_CONFIG_BACKUP_DIR}
				fi
				\cp -f ${LOGGER_DIR}/server/setting/common.config ${LOGGER_CONFIG_BACKUP_DIR}/common.config
			fi
			rm -rf ${LOGGER_DIR}/server
			\cp -rf ${SERVER_DIR} ${LOGGER_DIR}/server
			rm -rf ${LOGGER_DIR}/server/*.lock
			if [ -f ${LOGGER_CONFIG_BACKUP_DIR}/common.config ] ; then
				\cp -f ${LOGGER_CONFIG_BACKUP_DIR}/common.config ${LOGGER_DIR}/server/setting/common.config 
				rm -rf ${LOGGER_CONFIG_BACKUP_DIR}
			fi
	        echo "部署完成，目录为:${LOGGER_DIR}"
	        echo "请修改服务的相关配置并启动，重点配置日志节点的数据对应信息"
	        echo "${LOGGER_DIR}/server/setting/common.config"
	        ;;
	n|N|no|No) 
			echo "使用 sh dev.sh deploy_logger xxx_xx 来修改部署目录"
	        exit 0
	        ;;
	        *)
			echo "使用 sh dev.sh deploy_logger xxx_xx 来修改部署目录"
	        exit 0
	        ;;
	esac
}
## 同步配置文件到SVN
do_sync_server_conf()
{
	## SVN仓库目录
	SVN_USER=ydev
	SVN_PASSWORD=Z2j8WkTuKAwncYPQ
	SVN_REPOSITORY="http://192.168.1.211/yujian"
	SVN_AUTH="--non-interactive --no-auth-cache  --username=${SVN_USER} --password=${SVN_PASSWORD}"
	S_SVN_URL="${SVN_REPOSITORY}/server/trunk ${SVN_AUTH}"
	#切换到代码根目录
	cd ${SHELL_DIR}
	/usr/bin/svn up
	cd ${SHELL_DIR}/config
	/usr/bin/svn add * --force ${SVN_AUTH}
	cd ${SHELL_DIR}
	/usr/bin/svn commit ${SHELL_DIR}/config/  ${SVN_AUTH} -m "【开发】发布脚本提交文件,提交生成的后端配置文件"
	/usr/bin/svn commit ${SHELL_DIR}/front-end/  ${SVN_AUTH} -m "【开发】发布脚本提交文件,提交生成的前端配置文件"
	/usr/bin/svn commit ${SHELL_DIR}/hrl/  ${SVN_AUTH} -m "【开发】发布脚本提交文件,提交生成的hrl文件"
}
## 同步配置文件到客户端SVN
do_sync_client_conf()
{
	## SVN仓库目录
	SVN_USER=ydev
	SVN_PASSWORD=Z2j8WkTuKAwncYPQ
	SVN_REPOSITORY="http://192.168.1.211/yujian"
	SVN_AUTH="--non-interactive --no-auth-cache  --username=${SVN_USER} --password=${SVN_PASSWORD}"
	S_SVN_URL="${SVN_REPOSITORY}/client/YuJian/Assets/Data/LusScript/config ${SVN_AUTH}"
	C_CONFIG_DIR=/data/client/config
	#切换到代码根目录
	cd ${C_CONFIG_DIR}
	/usr/bin/svn up
	\cp -f ${SHELL_DIR}/front-end/p_defines.lua ${C_CONFIG_DIR}/proto/p_defines.lua
	\cp -f ${SHELL_DIR}/front-end/SocketCommand.lua ${C_CONFIG_DIR}/proto/SocketCommand.lua
	\cp -f ${SHELL_DIR}/front-end/toc_defines.lua ${C_CONFIG_DIR}/proto/toc_defines.lua
	\cp -f ${SHELL_DIR}/front-end/tos_defines.lua ${C_CONFIG_DIR}/proto/tos_defines.lua
	\cp -f ${SHELL_DIR}/front-end/errors.lua ${C_CONFIG_DIR}/errors.lua
	
	/usr/bin/svn commit ${C_CONFIG_DIR}/  ${SVN_AUTH} -m "【开发】发布脚本提交文件,提交生成的前端端配置文件"
	
	PROTOCOL_SVN_URL="${SVN_REPOSITORY}/doc/server/protocol ${SVN_AUTH}"
	PROTOCOL_DIR=/data/client/protocol
	if [ ! -d ${PROTOCOL_DIR} ] ; then
		/usr/bin/svn checkout ${SVN_AUTH} ${PROTOCOL_SVN_URL} ${PROTOCOL_DIR}
	fi
	cd ${PROTOCOL_DIR}
	/usr/bin/svn up
	\cp -f ${SHELL_DIR}/proto/common.proto ${PROTOCOL_DIR}/common.proto
	\cp -f ${SHELL_DIR}/proto/game.proto ${PROTOCOL_DIR}/game.proto
	\cp -f ${SHELL_DIR}/proto/mm_map.xml ${PROTOCOL_DIR}/mm_map.xml
	
	/usr/bin/svn commit ${PROTOCOL_DIR}/  ${SVN_AUTH} -m "【开发】发布脚本提交文件,提交游戏协议描述文件"
}

## 脚本帮助信息
do_help()
{
	echo "    dev.sh 使用说明："
	echo "    基本语法: dev.sh Command [Option]"
	echo "        Command：命令说明："
	echo "            help                                 显示脚本帮助信息"
	echo "            make                                 编码代码"
    echo "            rebuild                              重新编码代码"
	echo "            clean                                清除代码"
	echo "            dialyzer                             erlang静态分析编译"
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
	echo "            deploy_logger[dlog]                  开发服务器部署日志服务"
	echo "            sync_server_conf[ssc]                服务端文件同步到SVN"
	echo "            sync_client_conf[scc]                同步配置文件到客户端SVN"
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
	make) do_main make $*;;
	rebuild) do_main rebuild $*;;
	clean) do_main clean $*;;
	dialyzer) do_main dialyzer $*;;
	start) do_main_run start $* ;;
	stop) do_main_run stop $*;;
	debug) do_main_run debug $*;;
	live) do_main_run live $*;;
	kick_role) do_main_run kick_role $*;;
    updb) do_main_run updb $*;;
    lixiancheji) do_main_run lixiancheji $*;;
    gen_merge_data) do_main_run gen_merge_data $*;;
	start_logger) do_main_run start_logger $*;;
	stop_logger) do_main_run stop_logger $*;;
	debug_logger) do_main_run debug_logger $*;;
	live_logger) do_main_run live_logger $*;;
	backup) do_main_run backup $*;;
	merge) do_main_run merge $*;;
    merged) do_main_run merge_deploy $*;;
    merge_deploy) do_main_run merge_deploy $*;;
	upbeam) do_main_run upbeam $*;;
	upconf) do_main_run upconf $*;;
	func) do_main_run func $*;;
	dlog) do_deploy_logger $*;;
	deploy_logger) do_deploy_logger $*;;
	ssc) do_sync_server_conf $*;;
	sync_server_conf) do_sync_server_conf $*;;
	scc) do_sync_client_conf $*;;
	sync_client_conf) do_sync_client_conf $*;;
	*) do_help ;;
esac