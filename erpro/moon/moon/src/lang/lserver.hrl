%%------------------------------------------------
%% 定义各版本翻译排除文件列表
%%-----------------------------------------------
%% 台服
-ifdef(tw).
-define(ignore_files, [
        "/../src/mod/misc/fcm_kr.erl"
    ]
).
-define(lang_nation, "tw").
-endif.

%% 韩国服
-ifdef(kr).
-define(ignore_files, []).
-define(lang_nation, "kr").
-endif.

%% 越南服
-ifdef(vnm).
-define(ignore_files, [
        "/../src/mod/misc/fcm_kr.erl"
    ]
).
-define(lang_nation, "vnm").
-endif.

%% 泰國服
-ifdef(thai).
-define(ignore_files, [
        "/../src/mod/misc/fcm_kr.erl"
    ]
).
-define(lang_nation, "thai").
-endif.

%% 泰國服
-ifdef(id).
-define(ignore_files, [
        "/../src/mod/misc/fcm_kr.erl"
    ]
).
-define(lang_nation, "id").
-endif.

%% 默认宏定义
-ifndef(tw).
-ifndef(kr).
-ifndef(vnm).
-ifndef(thai).
-ifndef(id).
-define(ignore_files, []).
-define(lang_nation, "error").
-endif.
-endif.
-endif.
-endif.
-endif.

%% 定义指定目录，指定后缀的忽略文件，所有翻译版本
-define(common_ignore_dirs_exts, [
        {"/../src/mod/log", ".erl"}
        ,{"/../src/tester", ".erl"}
        ,{"/../src/proto", ".erl"}
        ,{"/../src/lang", ".erl"}
        ,{"/../src/lang", ".hrl"}
        ,{"/../src/lib/mysql", ".erl"}
    ]
).

%% 定义指定的不需要翻译文件， 所有翻译版本
-define(common_ignore_files, [
        "/../src/mod/misc/fcm.erl"
        ,"/../src/mod/misc/fcm_dao.erl"
        ,"/../src/mod/misc/fcm_rpc.erl"
        ,"/../src/mod/misc/filter_data.erl"
        ,"/../src/mod/adm/adm_sys_db.erl"
        ,"/../src/dev.erl"
        ,"/../src/adm.erl"
        ,"/../src/mod/arena/m.erl"
        ,"/../src/mod/role/role_adm_rpc.erl"
        ,"/../src/mod/role/role_adm.erl"
        ,"/../src/merge/merge_db.erl"
        ,"/../src/merge/merge_data.erl"
        ,"/../src/merge/merge_checker"
        ,"/../src/mod/mail/mail_adm.erl"
        ,"/../src/mod/rank/rank_log.erl"
        ,"/../src/lib/calendar.erl"
        ,"/../src/lib/srv_id_mapping.erl"
     ]
).
