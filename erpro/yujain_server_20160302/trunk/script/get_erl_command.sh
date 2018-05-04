#!/bin/bash

if [ "$1" = '' ] ; then
    echo -e '=======================================警告==================================='
    echo -e "  获取erl命令"
    echo -e "  /bin/bash get_erl_command.sh erl"
    echo -e "  获取erlc命令"
    echo -e "  /bin/bash get_erl_command.sh erlc"
    echo -e '=======================================警告===================================\n'
    exit 1
fi

## TYPE 为命令类型  erl,erlc
TYPE=$1

## 检查ERLANG 版本
TARGET_ERLANG="17"
OTP_RELEASE=`erl -noshell -eval 'R = erlang:system_info(otp_release), io:format("~s", [R])' -s erlang halt`
if [ "${OTP_RELEASE}" = "${TARGET_ERLANG}" ] ; then
	ERL=erl
	ERLC=erlc
else
	ERL=""
	ERLC=""
fi
if [ "${TYPE}" = "erlc" ] ; then
	echo ${ERLC}
else
	echo ${ERL}
fi
	