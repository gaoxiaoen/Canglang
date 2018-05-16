@echo off

rem ---------------------------------------------------------
rem ���ƽű�
rem @author kqqsysu@gmail.com
rem ---------------------------------------------------------

rem erl����Ŀ¼
set DIR_ERL=%~dp0
set EBIN_DIR=""
set WERL="%EBIN_DIR%werl"
set ERL="%EBIN_DIR%erl"
set ESCRIPT="%EBIN_DIR%escript"

rem ��Ϸ����ͳһ����
set OPENTIME=1425974597
set TICK="3e1f8f56ad582a7e76f8ef8adef0a54c"
set LOG_LEVEL=6
set DEBUG=1
set DB_HOST="127.0.0.1"
set DB_PORT=3306
set DB_USER="root"
set DB_PASS="123456"
set OS="win"
set IP="127.0.0.1"
SET ERL_COOKIE="onhook_dev"
SET KF_COOKIE="cl168arpg"


rem ���ڵ��������
set GAME=onhook_dev
set SERVER_NUM=1
set PORT=8001
set DB_NAME="hqg_arpg"



rem ����ڵ��������
set KF_GAME=center0
set KF_SERVER_NUM=50001
set KF_PORT=8002


rem ����ڵ�2�������
set KF_GAME2=center1
set KF_SERVER_NUM2=50002
set KF_PORT2=8003



rem ��˱��������
set MMAKER_PROCESS=16

set inp=%1
if "%inp%" == "" goto fun_wait_input
goto fun_run

:fun_wait_input
    set inp=
    echo.
    echo ==============================
    echo make: ��������Դ��
    echo data: �������ñ�
    echo start: ������Ϸ�ڵ�
    echo center: ����center�ڵ�
    echo center2: ����center2�ڵ�
    echo stop: �رշ�����
    echo kill: ǿ��kill������werl.exe����
    echo dialyzer: dialyzer����
	  echo filter_log: ��־���˷���
    echo clean: ����erlang������
    echo quit: ��������
	  echo ctags: ����vim tags
	  echo proto: ����Э��
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
	  if [%inp%]==[data] goto fun_data
    if [%inp%]==[start] goto fun_start_start
    if [%inp%]==[center] goto fun_start_center
    if [%inp%]==[center2] goto fun_start_center2
    if [%inp%]==[stop] goto fun_stop_server
    if [%inp%]==[kill] goto fun_kill
    if [%inp%]==[clean] goto fun_clean
	  if [%inp%]==[dialyzer] goto fun_dialyzer
	  if [%inp%]==[filter_log] goto fun_filter_log
	  if [%inp%]==[ctags] goto fun_ctags
	  if [%inp%]==[proto] goto fun_proto
    if [%inp%]==[quit] goto end
    goto where_to_go


:fun_make
    rem ��������
	  call :fun_mmaker 
    set arg=
    cd %DIR_ERL%
	  goto fun_make_debug
    goto where_to_go

:fun_data
	cd %DIR_ERL%/../../excel
	call run.bat
	goto where_to_go
	
:fun_make_debug
    cd %DIR_ERL%/../
    %ERL% -pa ebin -noinput -eval "case mmake:all(%MMAKER_PROCESS%,[{outdir, \"ebin\"},{d,'DEBUG_BUILD'}])  of up_to_date -> halt(0); error -> halt(1) end. "
    goto where_to_go

:fun_start_start
    rem �������ڵ�
    cd %DIR_ERL%/../config
    start "" "%WERL%" -hidden -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 -smp enable -pa ../ebin -pa ../sbin -name %GAME%@%IP% -setcookie %ERL_COOKIE% -boot start_sasl -config server  -s game server_start -extra %SERVER_NUM% %IP% %PORT% %OPENTIME% %TICK% %LOG_LEVEL% %DEBUG% %DB_HOST% %DB_PORT% %DB_USER% %DB_PASS% %DB_NAME% %OS%	
    goto where_to_go
	
:fun_start_center
    rem ��������ڵ�
    cd %DIR_ERL%/../config
    start "" "%WERL%" -hidden -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 -smp enable -pa ../ebin -pa ../sbin -name %KF_GAME%@%IP% -setcookie %KF_COOKIE% -boot start_sasl -config server  -s game server_start -extra %KF_SERVER_NUM% %IP% %KF_PORT% %OPENTIME% %TICK% %LOG_LEVEL% %DEBUG% %DB_HOST% %DB_PORT% %DB_USER% %DB_PASS% %DB_NAME% %OS%
		goto where_to_go

:fun_start_center2
    rem ��������ڵ�2
    cd %DIR_ERL%/../config
    start "" "%WERL%" -hidden -kernel inet_dist_listen_min %ERL_PORT_MIN% -kernel inet_dist_listen_max %ERL_PORT_MAX% +P 204800 -smp enable -pa ../ebin -pa ../sbin -name %KF_GAME2%@%IP% -setcookie %KF_COOKIE% -boot start_sasl -config server  -s game server_start -extra %KF_SERVER_NUM2% %IP% %KF_PORT2% %OPENTIME% %TICK% %LOG_LEVEL% %DEBUG% %DB_HOST% %DB_PORT% %DB_USER% %DB_PASS% %DB_NAME% %OS%
		goto where_to_go

:fun_kill
    rem ǿ��kill��werl.exe
    taskkill /F /IM werl.exe
    goto where_to_go

:fun_stop_server
    rem �رշ�����
    start "" "%WERL%" -name %GAME%_stop@%IP% -setcookie %ERL_COOKIE% -eval "rpc:call('%GAME%@%IP%',game,server_stop,[]),erlang:halt(0)"
    goto where_to_go

:fun_clean
    cd %DIR_ERL%\ebin
    del *.beam
    echo ����erlang���������
    goto where_to_go

:fun_dialyzer
	rem ����beam
	cd %DIR_ERL%\ebin
    del *.beam
	cd %DIR_ERL%
	cd script
	ESCRIPT gen_data.erl
	cd %DIR_ERL%
	%ERL%  -pa ebin -noinput -eval "case make:files([\"src/tool/mmake.erl\"],[debug_info,{outdir, \"ebin\"}]) of up_to_date -> halt(0); _ -> halt(1) end."
	%ERL%  -pa ebin -noinput -eval "case make:files([\"src/mod/common/gen_server2.erl\"],[debug_info,{outdir, \"ebin\"}]) of up_to_date -> halt(0); _ -> halt(1) end."
	%ERL%  -pa ebin -noinput -eval "case make:files([\"src/mod/common/gen_server3.erl\"],[debug_info,{outdir, \"ebin\"}]) of up_to_date -> halt(0); _ -> halt(1) end."	
	%ERL%  -pa ebin -noinput -eval "case make:files([\"src/ts.erl\"],[debug_info,{outdir, \"ebin\"}]) of up_to_date -> halt(0); _ -> halt(1) end."
	cd %DIR_ERL%\ebin
	rem make debug
	cd %DIR_ERL%
    %ERL% -pa ebin -noinput -eval "case mmake:all(%MMAKER_PROCESS%,[debug_info,{outdir, \"ebin\"}]) of up_to_date -> halt(0); error -> halt(1) end."
	rem dialyzer
	dialyzer -Werror_handling -r %DIR_ERL%\ebin > %DIR_ERL%\dialyzer.txt
	echo �������
    goto where_to_go
	
:fun_filter_log
	cd %DIR_ERL%/../
	%ERL%  -pa ebin -eval "filter_log:filter(\"%LOG_FILE_PATH%\"),halt(0)"
	goto where_to_go
	
:fun_ctags
	cd %DIR_ERL%/../
	ctags -R
	goto where_to_go

:fun_proto
	cd %DIR_ERL%/../../proto
	call run.bat
	goto where_to_go
	

:fun_mmaker
	cd %DIR_ERL%/../
	%ERL%  -pa ebin -noinput -eval "case make:files([\"src/tool/mmake.erl\"],[{outdir, \"ebin\"}]) of up_to_date -> halt(0); _ -> halt(1) end."
	rem %ERL%  -pa ebin -noinput -eval "case make:files([\"src/mod/common/gen_server2.erl\"],[{outdir, \"ebin\"}]) of up_to_date -> halt(0); _ -> halt(1) end."
	rem %ERL%  -pa ebin -noinput -eval "case make:files([\"src/mod/common/gen_server3.erl\"],[{outdir, \"ebin\"},{i,\"include\"}]) of up_to_date -> halt(0); _ -> halt(1) end."	
	rem %ERL%  -pa ebin -noinput -eval "case make:files([\"src/ts.erl\"],[{outdir, \"ebin\"},{i,\"include\"}]) of up_to_date -> halt(0); _ -> halt(1) end."

:end

