#!/bin/sh 

here=`which "$0" 2>/dev/null || echo .`
base="`dirname $here`"
SHELL_DIR=`(cd "$base"; echo $PWD)`

GAME_NAME=`grep "game_name" $SHELL_DIR/../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
AGENT_NAME=`grep "agent_name" $SHELL_DIR/../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`
SERVER_NAME=`grep "server_name" $SHELL_DIR/../setting/common.config | awk -F"," '{print $2}' | awk -F\" '{print $2}'`

BASE_DIR="/data/games/${GAME_NAME}_${AGENT_NAME}_${SERVER_NAME}"

LOG_DIR="/data/logs/${AGENT_NAME}_${SERVER_NAME}/"

#set +x
## erl -env ERL_MAX_PORTS 10000 -s mcs_autochat help
erl -pa $BASE_DIR/server/ebin -pa $BASE_DIR/server/ebin/common -pa $BASE_DIR/server/ebin/map -pa $BASE_DIR/server/ebin/map/mod -s mod_mission_check check -s init stop -server_dir $BASE_DIR/server/ -logs_dir $LOG_DIR 
echo 
echo
