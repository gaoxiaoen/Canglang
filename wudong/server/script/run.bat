cd ../config
set GAME=onhook_dev
set SERVER_NUM=1
set IP="127.0.0.1"
set PORT=8001
set OPENTIME=1425974597
set TICK="3e1f8f56ad582a7e76f8ef8adef0a54c"
set LOG_LEVEL=6
set DEBUG=1
set DB_HOST="127.0.0.1"
set DB_PORT=3306
set DB_USER="root"
set DB_PASS="123456"
set DB_NAME="hqg_arpg"
set OS="win"

erl	+P 1024000 ^
	-smp enable ^
	-pa ../ebin ^
	-pa ../sbin ^
	-name %GAME%@%IP% ^
	-setcookie %GAME% ^
	-boot start_sasl ^
	-config server  ^
	-s game server_start ^
	-extra %SERVER_NUM% %IP% %PORT% %OPENTIME% %TICK% %LOG_LEVEL% %DEBUG% %DB_HOST% %DB_PORT% %DB_USER% %DB_PASS% %DB_NAME% %OS%

pause
