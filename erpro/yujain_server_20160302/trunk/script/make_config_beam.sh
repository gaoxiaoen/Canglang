#!/bin/bash
## 根据config文件生成beam文件
echo "正在预编译config文件中，请稍等..."

if [ "$1" != "" ] ; then
    Worker=$1
else
    Worker=1
fi

if [ "$2" != "" ] ; then
	ERL=$2
else
	## 检查ERLANG 版本
	ERL=`sh ../script/get_erl_command.sh erl`
	if [ "${ERL}" = "" ] ; then
		echo "Erlang 版本出错，请检查并联系开发人员"
		exit 0
	fi
fi

## 获取agent_name和server_name
GAME_NAME=`grep "game_name" ../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
AGENT_NAME=`grep "agent_name" ../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
SERVER_NAME=`grep "server_name" ../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
## 根目录设置
BASE_DIR="/data/games/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}"
LOG_DIR="/data/logs/${AGENT_NAME}_${SERVER_NAME}"
# 扩展参数
SERVER_DIR=${BASE_DIR}/server
SETTING_FILE=${BASE_DIR}/server/setting/common.config
EXT_PARAM="-server_dir ${SERVER_DIR} -setting_file ${SETTING_FILE} -log_dir ${LOG_DIR} -server_data_dir ${SERVER_DIR}"

${ERL} -pa $BASE_DIR/server/ebin/common/ -s common_config_dyn gen_all_beam -noinput -s erlang halt ${EXT_PARAM}
mkdir -p $BASE_DIR/server/ebin/config/
cd ../config/src
make -j ${Worker}
rm -f *_config_codegen.erl
echo "config文件编译成功"
