#!/bin/bash
ulimit -SHn 102400
/usr/local/bin/erl -kernel inet_dist_listen_min 40001 -kernel inet_dist_listen_max 40100 +P 204800 +K true -smp enable -name master@mhfx.merge -setcookie merge_cookie -config elog -s merge_main start -extra immediacy
