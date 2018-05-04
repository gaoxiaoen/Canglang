@echo off

rem ---------------------------------------------------------
rem ���ƽű���windows�棩��ʹ��ǰ����ȷ�������±�����
rem @author yeahoo2000@gmail.com
rem ---------------------------------------------------------

rem erl���������Ŀ¼
set DIR_ERL=E:\proj1\server
rem web���������Ŀ¼
set DIR_WEB=f:\p1\dev\web
rem client����Ŀ¼
set DIR_CLI=f:\p1\dev\client
rem ��Դ������Ŀ¼
set DIR_RES=d:\mhfx\resources
rem ���߿�����Ŀ¼
set DIR_TLS=f:\p1\dev\tools

rem erlang����������Ŀ¼
set ERL=werl
rem php����������Ŀ¼
set PHP=php.exe

rem ���ڵ��������
set MASTER_NAME=master
rem �ڵ�����
set MASTER_DOMAIN=192.168.8.41
rem �����˿ں�
set MASTER_PORT=8010
rem �ӽڵ��������
set SLAVE_NAME=slave
rem �ڵ�����
set SLAVE_DOMAIN=192.168.15.28
rem �����˿ں�
set SLAVE_PORT=8001
rem erlang�ڵ�ͨѶcookie
set ERL_COOKIE=c3c9j1a1c9c7b3d4
rem erl�ڵ��ͨѶ�˿�
set ERL_PORT_MIN=40001
set ERL_PORT_MAX=40100
set inp=%1
if "%inp%" == "" goto fun_wait_input
goto fun_run

:fun_wait_input
    set inp=
    echo.
    echo ==============================
    echo make: ��������Դ��(�ر�sql����, socket����)
    echo debug_sql: ����sql����
    echo debug_socket: ����socket����
    rem echo cfg_update: ���������ļ�[dev.bat, ctl.sh, default.cfg.php main.app��]
    rem echo proto: ����Э������ļ�
    rem echo edoc: ����API�ĵ�
    echo master: ����master�ڵ�
    rem echo slave: ����slave�ڵ�
    echo stop: �رշ�����
    echo kill: ǿ��kill������werl.exe����
    rem echo convert: ת��Excel��erl
    echo shell: ����һ��erlang shell
    rem echo client: ���ؿͻ�����Դ������
    echo clean: ����erlang������
    rem echo up: ���±���svn
    echo quit: ��������
    echo ------------------------------
    set /p inp=������ָ��:
    echo ------------------------------
    goto fun_run

:where_to_go
    rem �����Ƿ���������в���
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
    rem ����һ��erl��shell
    set name=
    cd %DIR_ERL%\ebin
    set /p name=������ڵ���[Ĭ��Ϊ"shell"]:
    if not [%name%]==[] start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name %name%@%MASTER_DOMAIN% -setcookie %ERL_COOKIE%
    if [%name%]==[] start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name shell@%MASTER_DOMAIN% -setcookie %ERL_COOKIE%
    goto where_to_go

:fun_make
    rem ��������
    set arg=
    cd %DIR_ERL%
    echo Ĭ����debugģʽ���򿪺�?DEBUG�������
    rem echo sql �������ݿ����ģʽ����ӡ���е�SQL��ѯ��Ϣ
    rem echo socket ����socket����ģʽ����ӡ�����շ���socket����
    echo release ���뷢���汾���ر����еĵ������
    set /p arg=������������:
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
    echo ���ڱ���cbin...
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
    echo ���ڸ������е������ļ�...
    %PHP% setup\setup.php update
    goto where_to_go

:fun_proto
    echo ����Э��žͿ�������ָ��Э��
    echo Ĭ����������Э��
    set arg2=
    set /p arg2=������Э���:
    cd %DIR_TLS%\protocol
    del %DIR_CLI%\src\webgame\commands\incomming\*.* /f/q
    del %DIR_CLI%\src\webgame\commands\outgoing\*.* /f/q
    if [%arg2%]==[] %PHP% gen.php
    if not [%arg2%]==[] %PHP% gen2.php proto_%arg2%
    echo �������
    goto where_to_go

:fun_edoc
    echo ��������API�ĵ�...
    cd %DIR_ERL%
    mkdir tmp
    xcopy src\* tmp /s/q/y
    xcopy ..\core\src\*.erl tmp /s/q/y
    cd %DIR_ERL%\ebin
    erl -eval "dev:edoc()" -s c q
    del ..\tmp /f/q
    rd ..\tmp /q
    echo �������
    goto where_to_go

:fun_start_master
    rem �������ڵ�
    cd %DIR_ERL%\ebin
    start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name %MASTER_NAME%@%MASTER_DOMAIN% -setcookie %ERL_COOKIE% -config elog -s main start -extra master %MASTER_DOMAIN% %MASTER_PORT%
    goto where_to_go

:fun_start_slave
    rem �����ӽڵ�
    cd %DIR_ERL%\ebin
    start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 +K true -smp enable -name %SLAVE_NAME%@%SLAVE_DOMAIN% -setcookie %ERL_COOKIE% -config elog -s main start -extra slave %MASTER_NAME%@%MASTER_DOMAIN% %SLAVE_DOMAIN% %SLAVE_PORT%
    goto where_to_go

:fun_kill
    rem ǿ��kill��werl.exe
    taskkill /F /IM werl.exe
    goto where_to_go

:fun_convert
    rem ��Excelת����Ϊerl
    cd %DIR_TLS%\convert
    echo ת���߻����ݣ������ǿ�ת������������:
    echo 
    echo task ת����������
    echo role_exp ת����������
    echo role_attr ת����ɫ��������
    echo npc ת��NPC����
    echo npc_store ת��NPC�̵�����
    echo map ת����ͼ����
    echo item ת����Ʒ����
    echo buff ת��BUFF����
    echo skill ת����������
    echo fuse ת����¯����
    echo drop ת����������
    echo retreward ת��ǿ�����Խ�������
    echo combat_data_skill ת��ս����Ϊ��������
    echo eqm_data_reward ת��ǿ����������
    echo channel ת��Ԫ������
    echo pet ת����������
    echo pet_data_skill ת�����＼������
    echo task_data_drop ת�������������
    echo task_data_ring ת����������
    echo ...
    set /p arg=��ѡ��:
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
    if [%arg%]==[] echo ��Ч������
    goto where_to_go

:fun_stop_server
    rem �رշ�����
    cd %DIR_ERL%\ebin
    start %ERL% -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% -name %MASTER_NAME%_stop@%MASTER_DOMAIN% -setcookie %ERL_COOKIE% -config elog -s main stop_from_shell -extra %MASTER_NAME%@%MASTER_DOMAIN%
    goto where_to_go

:fun_client_download
    rem ���¿ͻ�����Դ�ļ�
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
    echo ����erlang���������
    goto where_to_go

:fun_up
    TortoiseProc.exe /command:update /path:%DIR_ERL%
    TortoiseProc.exe /command:update /path:%DIR_CLI%
    TortoiseProc.exe /command:update /path:%DIR_TLS%
:end
