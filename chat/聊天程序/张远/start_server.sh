COOKIE=xyyo
NODE_NAME=zhangyuan@127.0.0.1
CONFIG_FILE=server

SMP=auto
ERL_PROCESSES=102400

erl +P $ERL_PROCESSES -smp $SMP -pa ./ebin -name $NODE_NAME -setcookie $COOKIE -boot start_sasl -config $CONFIG_FILE -s main chat_server_start

