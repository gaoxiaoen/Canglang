@echo off

rem ---------------------------------------------------------
rem 控制脚本（windows版）（使用前需正确设置以下变量）
rem @author yeahoo2000@gmail.com
rem ---------------------------------------------------------

rem erl服务端所在目录
set DIR_ERL=E:\proj1\server
rem web服务端所在目录
set DIR_WEB=f:\p1\dev\web
rem client所在目录
set DIR_CLI=f:\p1\dev\client
rem 资源库所在目录
set DIR_RES=d:\mhfx\resources
rem 工具库所在目录
set DIR_TLS=f:\p1\dev\tools

rem erlang主程序所在目录
set ERL=werl
rem php主程序所在目录
set PHP=php.exe

rem 主节点相关设置
set MASTER_NAME=master
rem 节点域名
set MASTER_DOMAIN=192.168.8.41
rem 监听端口号
set MASTER_PORT=8010
rem 从节点相关设置
set SLAVE_NAME=slave
rem 节点域名
set SLAVE_DOMAIN=192.168.15.28
rem 监听端口号
set SLAVE_PORT=8001
rem erlang节点通讯cookie
set ERL_COOKIE=c3c9j1a1c9c7b3d4
rem erl节点间通讯端口
set ERL_PORT_MIN=40001
set ERL_PORT_MAX=40100
set inp=%1
if "%inp%" == "" goto fun_wait_input
goto fun_run

:fun_wait_input
    set inp=
    echo.
    echo ==============================
    echo make: 编译服务端源码(关闭sql调试, socket调试)
    echo debug_sql: 开启sql调试
    echo debug_socket: 开启socket调试
    rem echo cfg_update: 更新配置文件[dev.bat, ctl.sh, default.cfg.php main.app等]
    rem echo proto: 生成协议解析文件
    rem echo edoc: 生成API文档
    echo master: 启动master节点
    rem echo slave: 启动slave节点
    echo stop: 关闭服务器
    echo kill: 强行kill掉所有werl.exe进程
    rem echo convert: 转换Excel到erl
    echo shell: 开启一个erlang shell
    rem echo client: 下载客户端资源并更新
    echo clean: 清理erlang编译结果
    rem echo up: 更新本地svn
    echo quit: 结束运行
    echo ------------------------------
    set /p inp=请输入指令:
    echo ------------------------------
    goto fun_run

:where_to_go
    rem 区分是否带有命令行参数
    if [%1]==[] goto fun_wait_input
    goto end

:fun_run
    if [%inp%]==[make] goto fun_make
    if [%inp%]==[debug_sql] goto fun_debug_sql
    if [%inp%]==[debug_socket] goto fun_debug_socket
    if [%inp%]==[make_core] goto fun_make_core
    if [%inp%]==[cfg_update] goto fun_cfg_update
    if [%inp%]==[proto] goto fun_proto
    if [%inp%]==[edoc] goto fun_edoc
    if [%inp%]==[master] goto fun_start_master
    if [%inp%]==[slave] goto fun_start_slave
    if [%inp%]==[stop] goto fun_stop_server
    if [%inp%]==[shell] goto fun_shell
    if [%inp%]==[kill] goto fun_kill
    if [%inp%]==[convert] goto fun_convert
    if [%inp%]==[client] goto fun_client_download
    if [%inp%]==[clean] goto fun_clean
    if [%inp%]==[up] goto fun_up
    if [%inp%]==[quit] goto end
    goto where_to_go

:fun_shell
    rem 开启一个erl的shell
    set name=
    cd %DIR_ERL%\ebin
    set /p name=请输入节点名[默认为"shell"]:
    if not [%name%]==[] start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name %name%@%MASTER_DOMAIN% -setcookie %ERL_COOKIE%
    if [%name%]==[] start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name shell@%MASTER_DOMAIN% -setcookie %ERL_COOKIE%
    goto where_to_go

:fun_make
    rem 编译命令
    set arg=
    cd %DIR_ERL%
    echo 默开启debug模式，打开宏?DEBUG的输出等
    rem echo sql 开启数据库调试模式，打印所有的SQL查询信息
    rem echo socket 开启socket调试模式，打印所有收发的socket数据
    echo release 编译发布版本，关闭所有的调试输出
    set /p arg=请输入编译参数:
    if [%arg%]==[sql] goto fun_make_sql
    if [%arg%]==[socket] goto fun_make_socket
    if [%arg%]==[release] goto fun_make_release
    if [%arg%]==[] goto fun_make_debug
    goto where_to_go

:fun_make_debug
    cd %DIR_ERL%
    erl -eval "make:all([{d, debug},{outdir, \"ebin\"}])" -s c q -pa ebin
    copy cbin\debug\*.* ebin\
    goto where_to_go

:fun_debug_sql
    cd %DIR_ERL%
    del ebin\boot_misc.beam /q
    copy cbin\debug\boot_misc.debug_sql.beam ebin\boot_misc.beam
    goto where_to_go

:fun_debug_socket
    cd %DIR_ERL%
    del ebin\sys_conn.beam /q
    move cbin\debug\sys_conn.debug_socket.beam ebin\sys_conn.beam
    goto where_to_go

:fun_make_release
    cd %DIR_ERL%\ebin_release
    del *.beam
    cd %DIR_ERL%
    erl -eval "make:all([{outdir, \"ebin_release\"}])" -s c q -pa ebin
    rem copy cbin\release\*.* ebin_release\
    goto where_to_go

:fun_make_core
    echo 正在编译cbin...
    cd %DIR_ERL%\..\core
    copy %DIR_ERL%\inc\*.* inc\
    del ebin\sys_conn_dbg.beam
    del ebin\sys_conn_socket.beam
    del ebin\boot_misc_dbg.beam
    del ebin\boot_misc_sql.beam
    erl -eval "make:all([{d, debug}])" -s c q
    move ebin\boot_misc.beam ebin\boot_misc_dbg.beam

    erl -eval "make:all([{d, debug}, {d, debug_sql}])" -s c q
    move ebin\sys_conn.beam ebin\sys_conn_dbg.beam
    move ebin\boot_misc.beam ebin\boot_misc_sql.beam

    erl -eval "make:all([{d, debug}, {d, debug_socket}])" -s c q
    move ebin\sys_conn.beam ebin\sys_conn_socket.beam

    erl -eval "make:all([])" -s c q

    del %DIR_ERL%\cbin\* /q
    copy ebin\*.beam %DIR_ERL%\cbin\
    goto where_to_go

:fun_cfg_update
    echo 正在更新所有的配置文件...
    %PHP% setup\setup.php update
    goto where_to_go

:fun_proto
    echo 输入协议号就可以生成指定协议
    echo 默认生成所有协议
    set arg2=
    set /p arg2=请输入协议号:
    cd %DIR_TLS%\protocol
    del %DIR_CLI%\src\webgame\commands\incomming\*.* /f/q
    del %DIR_CLI%\src\webgame\commands\outgoing\*.* /f/q
    if [%arg2%]==[] %PHP% gen.php
    if not [%arg2%]==[] %PHP% gen2.php proto_%arg2%
    echo 生成完毕
    goto where_to_go

:fun_edoc
    echo 正在生成API文档...
    cd %DIR_ERL%
    mkdir tmp
    xcopy src\* tmp /s/q/y
    xcopy ..\core\src\*.erl tmp /s/q/y
    cd %DIR_ERL%\ebin
    erl -eval "dev:edoc()" -s c q
    del ..\tmp /f/q
    rd ..\tmp /q
    echo 生成完毕
    goto where_to_go

:fun_start_master
    rem 启动主节点
    cd %DIR_ERL%\ebin
    start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name %MASTER_NAME%@%MASTER_DOMAIN% -setcookie %ERL_COOKIE% -config elog -s main start -extra master %MASTER_DOMAIN% %MASTER_PORT%
    goto where_to_go

:fun_start_slave
    rem 启动从节点
    cd %DIR_ERL%\ebin
    start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name %SLAVE_NAME%@%SLAVE_DOMAIN% -setcookie %ERL_COOKIE% -config elog -s main start -extra slave %MASTER_NAME%@%MASTER_DOMAIN% %SLAVE_DOMAIN% %SLAVE_PORT%
    goto where_to_go

:fun_kill
    rem 强制kill掉werl.exe
    taskkill /F /IM werl.exe
    goto where_to_go

:fun_convert
    rem 将Excel转换成为erl
    cd %DIR_TLS%\convert
    echo 转换策划数据，以下是可转换的数据类型:
    echo 
    echo task 转换任务数据
    echo role_exp 转换经验数据
    echo role_attr 转换角色属性数据
    echo npc 转换NPC数据
    echo npc_store 转换NPC商店数据
    echo map 转换地图数据
    echo item 转换物品数据
    echo buff 转换BUFF数据
    echo skill 转换技能数据
    echo fuse 转换炼炉数据
    echo drop 转换掉落数据
    echo retreward 转换强化抗性奖励数据
    echo combat_data_skill 转换战斗行为配置数据
    echo eqm_data_reward 转换强化奖励数据
    echo channel 转换元神数据
    echo pet 转换宠物数据
    echo pet_data_skill 转换宠物技能数据
    echo task_data_drop 转换任务掉落数据
    echo task_data_ring 转换任务环数据
    echo ...
    set /p arg=请选择:
    if [%arg%]==[task] %PHP% convert2.php task_data
    if [%arg%]==[task_data_drop] %PHP% convert_comm.php task_data_drop
    if [%arg%]==[task_data_ring] %PHP% convert2.php task_data_ring
    if [%arg%]==[role_exp] %PHP% convert_comm.php role_exp_data
    if [%arg%]==[role_attr] %PHP% convert_comm.php role_attr_data
    if [%arg%]==[npc] %PHP% convert_comm.php npc_data
    if [%arg%]==[map] %PHP% convert_comm.php map_data
    if [%arg%]==[item] %PHP% convert2.php item_data
    if [%arg%]==[buff] %PHP% convert_comm.php buff_data
    if [%arg%]==[skill] %PHP% convert_comm.php skill_data
    if [%arg%]==[fuse] %PHP% convert_comm.php fuse_data
    if [%arg%]==[weapon] %PHP% convert_comm.php weapon_data
    if [%arg%]==[weapon2] %PHP% convert_comm.php weapon2_data
    if [%arg%]==[drop] %PHP% convert2.php drop_data
    if [%arg%]==[gemeffect] %PHP% convert_comm.php gemeffect_data
    if [%arg%]==[npc_store] %PHP% convert_comm.php npc_store_data
    if [%arg%]==[suit] %PHP% convert_comm.php suit_data
    if [%arg%]==[vip] %PHP% convert_comm.php vip_data
    if [%arg%]==[combat_data_skill] %PHP% convert_comm.php combat_data_skill
    if [%arg%]==[eqm_data_reward] %PHP% convert_comm.php eqm_data_reward
    if [%arg%]==[retreward] %PHP% convert_comm.php retreward_data
    if [%arg%]==[channel] %PHP% convert_comm.php channel_data
    if [%arg%]==[] echo 无效的输入
    goto where_to_go

:fun_stop_server
    rem 关闭服务器
    cd %DIR_ERL%\ebin
    start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% -name %MASTER_NAME%_stop@%MASTER_DOMAIN% -setcookie %ERL_COOKIE% -config elog -s main stop_from_shell -extra %MASTER_NAME%@%MASTER_DOMAIN%
    goto where_to_go

:fun_client_download
    rem 更新客户端资源文件
    cd %DIR_WEB%\www\g
    del /s /q loader.swf
    del /s /q debug.swf
    del /s /q main.swf
    del /s /q mainloading.swf
    del /s /q mainloading_bg.swf
    rem loading...
    %DIR_TLS%\wget.exe http://mhfx.dev/g/loader.swf loader.swf
    %DIR_TLS%\wget.exe http://mhfx.dev/g/debug.swf debug.swf
    %DIR_TLS%\wget.exe http://mhfx.dev/g/main.swf main.swf
    %DIR_TLS%\wget.exe http://mhfx.dev/g/mainloading.swf mainloading.swf
    %DIR_TLS%\wget.exe http://mhfx.dev/g/mainloading_bg.swf mainloading_bg.swf
    del /s /q *.html
    del /s /q *.html.*
    rem junction...
    %DIR_TLS%\junction.exe %DIR_WEB%\www\g\res d:\mhfx\resources\res\
    goto where_to_go

:fun_clean
    cd %DIR_ERL%\ebin
    del *.beam
    echo 清理erlang编译结果完成
    goto where_to_go

:fun_up
    TortoiseProc.exe /command:update /path:%DIR_ERL%
    TortoiseProc.exe /command:update /path:%DIR_CLI%
    TortoiseProc.exe /command:update /path:%DIR_TLS%
:end
