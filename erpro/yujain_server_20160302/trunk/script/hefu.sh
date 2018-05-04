#!/bin/bash

base="`dirname $0`"
SHELL_DIR=`(cd "$base"; echo $PWD)`
cd ${SHELL_DIR}

GAME_NAME=`grep "game_name" ../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
AGENT_NAME=`grep "agent_name" ../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
SERVER_NAME=`grep "server_name" ../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`

if [ -d /data/database/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}.old ] ; then
	rm -rf /data/database/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}.old
fi

mv /data/database/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME} /data/database/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}.old
cp -a /data/database/merge_data /data/database/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}

# 执行离线撤机操作，之后可以启动游戏
