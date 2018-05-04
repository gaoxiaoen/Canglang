#/bin/bash
# ---------------------------------------------------------
# 安装程序
# @author yeahoo2000@gmail.com
# ---------------------------------------------------------
GIT_CLIENT=git@183.60.44.155:client.git # flash客户端源码库地址
GIT_SERVER=git@183.60.44.155:server.git # erlang服务端源码库地址
GIT_RESOURCES=git@183.60.44.155:resources.git # 客户端资源库地址
GIT_WEB=git@183.60.44.155:web.git # web服务端源码库地址
GIT_TOOLS=git@183.60.44.155:tools.git # 工具库地址

DIR_ROOT=/Users/ghostgate/Documents/dev/proj_one/dev # 起始目录
DIR_ERL=/Users/ghostgate/Documents/dev/proj_one/dev/server # ERL服务端安装目录
DIR_WEB=/data/mhfx.develop/web # web服务端安装目录
DIR_CLI=/data/mhfx.develop/client # flash客户端安装目录
DIR_RES=/data/mhfx.develop/resources # 资源库安装目录
DIR_TLS=/data/mhfx.develop/tools # 辅助工具安装目录
DIR_PUB=/data/mhfx.develop/relase # 发布工作目录

MASTER_NAME=develop_master # 主节点名称
MASTER_DOMAIN=fx.dev # 主节点的所在域名或IP
MASTER_PORT=8010 # 主节点的监听端口号

SLAVE_NAME=develop_slave # 从节点名称
SLAVE_DOMAIN=fx.dev # 从节点的所在域名或IP
SLAVE_PORT=8011 # 从节点的监听端口号

ERL_COOKIE=develop_abc # erlang节点通讯cookie
ERL_PORT_MIN=40001 # erl节点间通讯端口
ERL_PORT_MAX=40100 # erl节点间通讯端口

ERL=erl # erlang主程序所在路径
PHP=/usr/bin/php  # php主程序所在路径
MXMLC=/usr/share/flex_sdk_4.0/bin/mxmlc # mxmlc的所在路径

## clone所有源码库
fun_clone(){
    cd ${DIR_ROOT}
    echo "正在检出erlang服务端源码"
    git clone ${GIT_SERVER}
    echo "正在检出flash客户端源码"
    git clone ${GIT_CLIENT}
    echo "正在检出WEB服务端源码"
    git clone ${GIT_WEB}
    echo "正在检出资源库"
    git clone ${GIT_RESOURCES}
    echo "正在检出工具库"
    git clone ${GIT_TOOLS}
    echo "全部检出完成"
}

## 更新所有源码库
fun_pull(){
    cd ${DIR_ERL}
    echo "正在更新erlang服务端源码"
    git pull
    cd ${DIR_CLI}
    echo "正在更新flash客户端源码"
    git pull
    cd ${DIR_WEB}
    echo "正在更新WEB端源码"
    git pull
    cd ${DIR_RES}
    echo "正在更新资源库"
    git pull
    cd ${DIR_TLS}
    echo "正在更新工具库"
    git pull
}

## 更新所有配置文件
fun_cfg_update(){
    ${PHP} setup/setup.php update
}

## 编译cbin
fun_make_core(){
    echo "正在编译cbin..."
    cd ${DIR_ERL}/../core
    cp -f ${DIR_ERL}/inc/*.* inc/
    rm -rf ebin/sys_conn_dbg.beam
    rm -rf ebin/sys_conn_socket.beam
    rm -rf ebin/boot_misc_dbg.beam
    rm -rf ebin/boot_misc_sql.beam

    ${ERL} -eval "make:all([native, {d, debug}])" -s c q
    mv -f ebin/boot_misc.beam ebin/boot_misc_dbg.beam

    ${ERL} -eval "make:all([native, {d, debug}, {d, debug_sql}])" -s c q
    mv -f ebin/sys_conn.beam ebin/sys_conn_dbg.beam 
    mv -f ebin/boot_misc.beam ebin/boot_misc_sql.beam

    ${ERL} -eval "make:all([native, {d, debug}, {d, debug_socket}])" -s c q
    mv -f ebin/sys_conn.beam ebin/sys_conn_socket.beam

    ${ERL} -eval "make:all([native])" -s c q

    rm -rf ${DIR_ERL}/cbin/*
    cp -f ebin/*.beam ${DIR_ERL}/cbin/

    echo "cbin编译完成"
}


## 编译服务端
fun_make_server(){
    cd ${DIR_ERL}
    ${ERL} -eval "make:all([{d, debug}, warnings_as_errors])" -s c q
    cp -f cbin/* ebin/
    #mv -f ebin/sys_conn_dbg.beam ebin/sys_conn.beam 
    #mv -f ebin/boot_misc_dbg.beam ebin/boot_misc.beam 
    echo "服务端编译完成"
}

## 编译客户端
fun_make_client(){
    cd ${DIR_CLI}
    echo "正在编译客户端源码"
    ${MXMLC} --show-actionscript-warnings=true --static-link-runtime-shared-libraries=true --strict=true --optimize=true --debug=true --library-path+=${DIR_CLI}/libs --source-path+=${DIR_CLI}/debuger --output=${DIR_WEB}/www/g/main.swf ${DIR_CLI}/src/DebugerMain.as
    echo "main.swf编译完成"
    ${MXMLC} --show-actionscript-warnings=true --static-link-runtime-shared-libraries=true --strict=true --optimize=true --debug=true --library-path+=${DIR_CLI}/libs --source-path+=${DIR_CLI}/src --source-path+=${DIR_CLI}/debuger --output=${DIR_WEB}/www/g/loader.swf ${DIR_CLI}/src/loader.as
    echo "loader.swf(DEBUG版)编译完成"
    cp ${DIR_RES}/mainloading.swf ${DIR_WEB}/www/g/
    cp ${DIR_RES}/mainloading_bg.swf ${DIR_WEB}/www/g/
}

## 发布服务端
fun_relase_server(){
    cd ${DIR_ERL}
    ${ERL} -eval "make:all([native])" -s c q
    cp -f cbin/* ebin/
    echo "服务端编译完成"
}

## 发布客户端
fun_relase_client(){
    cd ${DIR_CLI}
    ${MXMLC} --show-actionscript-warnings=true --static-link-runtime-shared-libraries=true --strict=true --optimize=true --debug=false --library-path+=${DIR_CLI}/libs --source-path+=${DIR_CLI}/debuger --output=${DIR_WEB}/www/g/main.swf ${DIR_CLI}/src/main.as
    echo "main.swf编译完成"
    ${MXMLC} --show-actionscript-warnings=true --static-link-runtime-shared-libraries=true --strict=true --optimize=true --debug=false --library-path+=${DIR_CLI}/libs --source-path+=${DIR_CLI}/debuger --output=${DIR_WEB}/www/g/loader.swf ${DIR_CLI}/src/loader.as
    echo "loader.swf编译完成"
    cp ${DIR_RES}/mainloading.swf ${DIR_WEB}/www/g/
    cp ${DIR_RES}/mainloading_bg.swf ${DIR_WEB}/www/g/
}

## 打包发布文件
fun_relase(){
    rm -rf ${DIR_PUB}
    mkdir ${DIR_PUB}

    echo "正在检出web源文件"
    git archive --remote ${GIT_WEB} -o ${DIR_PUB}/web_src.zip HEAD
    echo "正在检出server源文件"
    git archive --remote ${GIT_SERVER} -o ${DIR_PUB}/server_src.zip HEAD
    echo "正在检出resources资源文件"
    git archive --remote ${GIT_RESOURCES} -o ${DIR_PUB}/resources_src.zip HEAD
    echo "正在检出client源文件"
    git archive --remote ${GIT_CLIENT} -o ${DIR_PUB}/client_src.zip HEAD
    echo "正在检出tools源文件"
    git archive --remote ${GIT_TOOLS} -o ${DIR_PUB}/tools_src.zip HEAD

    echo "正在准备安装工具..."
    cp -R ${DIR_TLS}/setup ${DIR_PUB}/

    echo "正在准备ERL程序..."
    mkdir -p ${DIR_PUB}/server
    mkdir -p ${DIR_PUB}/server/ebin
    mkdir -p ${DIR_PUB}/server/var
    cp ${DIR_ERL}/ebin/*.config ${DIR_PUB}/server/ebin/
    cp ${DIR_ERL}/ebin/*.beam ${DIR_PUB}/server/ebin/

    echo "正在准备资源库..."
    unzip -o ${DIR_PUB}/resources_src.zip -d ${DIR_PUB}/resources/

    echo "正在准备WEB程序..."
    unzip -o ${DIR_PUB}/web_src.zip -d ${DIR_PUB}/web/
    mkdir -p ${DIR_PUB}/web/www/g/res
    cp ${DIR_WEB}/www/g/main.swf ${DIR_PUB}/web/www/g
    cp ${DIR_WEB}/www/g/loader.swf ${DIR_PUB}/web/www/g
    cp ${DIR_WEB}/www/g/mainloading.swf ${DIR_PUB}/web/www/g
    cp ${DIR_WEB}/www/g/mainloading_bg.swf ${DIR_PUB}/web/www/g
    cp ${DIR_PUB}/resources/mainloading.swf ${DIR_PUB}/web/www/g
    cp ${DIR_PUB}/resources/mainloading_bg.swf ${DIR_PUB}/web/www/g
    cp ${DIR_PUB}/resources/res/*.data ${DIR_PUB}/web/www/g/res

    echo "正在清理文件..."
    rm -rf ${DIR_PUB}/resources/res/*.data
    rm -rf ${DIR_PUB}/resources/*.swf
    find ${DIR_PUB}/resources -name *.psd -exec rm {} \;
    find ${DIR_PUB}/resources -name *.fla -exec rm {} \;
    echo "所有文件已经准备完毕."
}

## 启动主节点
fun_start_master(){
    start_file=${DIR_ROOT}/${MASTER_NAME}.sh
    CMD="${ERL} -hidden -kernel inet_dist_listen_min ${ERL_PORT_MIN} -kernel inet_dist_listen_max ${ERL_PORT_MAX} +P 204800 +K true -smp enable -name ${MASTER_NAME}@${MASTER_DOMAIN} -setcookie ${ERL_COOKIE} -config elog -s main start -extra master ${MASTER_DOMAIN} ${MASTER_PORT}"
    cat > ${start_file} <<EOF
#!/bin/bash
cd ${DIR_ERL}/ebin
ulimit -SHn 102400
${CMD}
EOF
    chmod +x ${start_file}
    screen -dmSL ${MASTER_NAME}@${MASTER_DOMAIN} -s ${start_file}
}

## 启动从节点
fun_start_slave(){
    start_file=${DIR_ROOT}/${SLAVE_NAME}.sh
    CMD="${ERL} -kernel inet_dist_listen_min ${ERL_PORT_MIN} -kernel inet_dist_listen_max ${ERL_PORT_MAX} +P 204800 +K true -smp enable -name ${MASTER_NAME}@${SLAVE_DOMAIN} -setcookie ${ERL_COOKIE} -config elog -s main start -extra slave ${MASTER_NAME}@${MASTER_DOMAIN} ${SLAVE_DOMAIN} ${SLAVE_PORT}"
    cat > ${start_file} <<EOF
#!/bin/bash
cd ${DIR_ERL}/ebin
ulimit -SHn 102400
${CMD}
EOF
    chmod +x ${start_file}
    screen -dmSL ${SLAVE_NAME}@${SLAVE_DOMAIN} -s ${start_file}
}

## 关闭服务器
fun_stop(){
    cd ${DIR_ERL}/ebin
    ${ERL} -kernel inet_dist_listen_min ${ERL_PORT_MIN} -kernel inet_dist_listen_max ${ERL_PORT_MAX} -name ${MASTER_NAME}_stop@${MASTER_DOMAIN} -setcookie ${ERL_COOKIE} -config elog -s main stop_from_shell -extra ${MASTER_NAME}@${MASTER_DOMAIN}
}

fun_hotswap(){
    echo "服务端编译ing"
    fun_make_server
    cd ${DIR_ERL}/ebin
    ${ERL} -kernel inet_dist_listen_min ${ERL_PORT_MIN} -kernel inet_dist_listen_max ${ERL_PORT_MAX} -name ${MASTER_NAME}_hotswap@${MASTER_DOMAIN} -setcookie ${ERL_COOKIE}  -eval "rpc:call('${MASTER_NAME}@${MASTER_DOMAIN}', dev, u, []), erlang:halt()."
}

## 清理erlang编译结果
fun_clean(){
    cd ${DIR_ERL}/ebin
    rm -f *.beam
    echo 清理erlang编译结果完成
}

## 命令行帮助
fun_help(){
    echo "clone         检出所有源码"
    echo "pull          更新所有源码"
    echo "cfg_update    更新所有配置文件"
    echo "make_server   编译服务端源码"
    echo "make_client   编译客户端源码"
    echo "relase_server 编译发布版服务端"
    echo "relase_client 编译发布版客户端"
    echo "relase        打包发布版的所有文件"
    echo "master        启动服务器"
    echo "slave         启动服务器"
    echo "clean         清理erlang编译结果"
    echo "stop          关闭服务器"
    echo "hotswap       热更"
}

## 执行入口
case $1 in
    clone) fun_clone;;
    pull) fun_pull;;
    cfg_update) fun_cfg_update;;
    make_core) fun_make_core;;
    make_server) fun_make_server;;
    make_client) fun_make_client;;
    relase_server) fun_relase_server;;
    relase_client) fun_relase_client;;
    relase) fun_relase;;
    clean) fun_clean;;
    master) fun_start_master;;
    slave) fun_start_slave;;
    stop) fun_stop;;
    cross_update) fun_cross_update;;
    hotswap) fun_hotswap;;
    *)
        echo "未知指令，请使用以下有效指令"
        echo "-------------------------------------------"
        fun_help
        exit 1
        ;;
esac
exit 0
