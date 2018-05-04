#!/bin/bash
## 执行生成所有脚本生成前端文件

base="`dirname $0`"
SHELL_DIR=`(cd "$base"; echo $PWD)`
cd ${SHELL_DIR}
if [ ! -d ${SHELL_DIR}/../front-end/ ]; then
	mkdir -p ${SHELL_DIR}/../front-end/
fi
php ${SHELL_DIR}/build_mm_map.php client

php ${SHELL_DIR}/build_proto_lua.php

php ${SHELL_DIR}/build_reason_code.php ${SHELL_DIR}/../hrl/reason_code.hrl ${SHELL_DIR}/../front-end/errors.lua

cd ${SHELL_DIR}/serialize

## 暂时去过滤词的生成
#php index.php wordfilter

cd ${SHELL_DIR}

echo "脚本执行完成,生成的结果如下:"

ls -l ${SHELL_DIR}/../front-end


