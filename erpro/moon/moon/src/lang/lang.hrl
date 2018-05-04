%%------------------------------------------------
%%定义 info 函数输出信息
%%------------------------------------------------
-define(pre_head, 4).   %% 语言文件每行头标志符占4个字节

%% -----------------------------------------------
%% 定义活动语言包处理使用相关
%% -----------------------------------------------
-define(lang_server_activity_dets_file, "../src/lang/server_activity.dets").
-define(lang_server_activity_dets_name, lang_server_activity).
-define(lang_server_activity_txt, "../src/lang/server_activity.txt").

%% ------------------------------------------------------
%% 定义服务端 语言包控制文件
%% ------------------------------------------------------
-define(lang_server_dets, "../src/lang/server.dets").
-define(lang_server_dets_name, lang_server).
-define(lang_server_done_union, "../src/lang/server_done_union.txt").
-define(lang_server_done_cn, "../src/lang/server_done_cn.txt").
-define(lang_server_done_nation(Nation), "../src/lang/server_done_" ++ Nation ++ ".txt").
-define(lang_server_undone_union, "../src/lang/server_undone_union.txt").
-define(lang_server_undone_cn, "../src/lang/server_undone_cn.txt").
-define(lang_server_undone_nation(Nation), "../src/lang/server_undone_" ++ Nation ++ ".txt").

%% ------------------------------------------------------
%% 定义策划数据 语言包控制文件
%% ------------------------------------------------------
-define(lang_xml_dets, "../src/lang/xml.dets").
-define(lang_xml_dets_name, lang_xml).
-define(lang_xml_done_union, "../src/lang/xml_done_union.txt").
-define(lang_xml_done_cn, "../src/lang/xml_done_cn.txt").
-define(lang_xml_done_nation(Nation), "../src/lang/xml_done_" ++ Nation ++ ".txt").
-define(lang_xml_undone_union, "../src/lang/xml_undone_union.txt").
-define(lang_xml_undone_cn, "../src/lang/xml_undone_cn.txt").
-define(lang_xml_undone_nation(Nation), "../src/lang/xml_undone_" ++ Nation ++ ".txt").

-define(lang_export_note, "[N]:翻译说明：\n[N]:前缀[N]:代表该行为注释内容。[ F ]:代表文件。[ S ]:代表简体内容。[ T ]:代表相应行数(单文件的对应上一行，多文件的是对应简体文件相同行数)简体的翻译内容。[ E ]:代表文件结尾。\n[N]:翻译方只需要将[ S ]:行的简体的翻译，并将对应翻译填写在[ T ]:行(单文件的对应下一行，多文件的是对应翻译文件相同行数)，请不要删除原文中的引号(\")，请不要添加原文中本没有的引号(\")。\n[N]:请不要额外使用简体中没有的符号(\",~)\n[N]:简体内容中的符号(【,】,“,”)请照旧采用，不要翻译成英文格式的([,],\")\n\n").

-define(lang_notice, "../src/lang/notice_default.txt").
-define(lang_notice_dets, "../src/lang/notice.dets").
-define(lang_notice_dets_name, notice).

%% 对比原中文时基准文件
-define(lang_server_translation_error, "../src/lang/server_translation_error.txt").
-define(lang_xml_translation_error, "../src/lang/xml_translation_error.txt").
-define(lang_server_error, "../src/lang/server_error.txt").

%% 翻译词库
-define(lang_server_words, "../src/lang/server_words.dets").
-define(lang_xml_words, "../src/lang/xml_words.dets").
-define(lang_server_lib, "../src/lang/server_lib.txt").
-define(lang_xml_lib, "../src/lang/xml_lib.txt").

%% 词条数据结构
-record(dict, {
        cn = <<>>           %% 简体词条
        ,mp                 %% 对应正则匹配参数 mp()
        ,tr = <<>>          %% 翻译内容
        ,status = false     %% 翻译状态     true | false
        ,index = 0          %% 文件导出顺序
        ,len = 0            %% 词条长度 用于替换排序，先替换词条最长的
        ,ver = now          %% 数据版本，now 表示当前版本在用, pre 表示以前版本中的，当前版本已经弃用的
    }
).
%% 文件数据结构
-record(lang, {
        file                %% 文件目录
        ,dicts = []         %% 词条列表
        ,index = 0          %% 文件导出顺序
    }
).

%% 词库
-record(word, {
        cn = <<>>
        ,tr = <<>>
   }
).

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

%% 定义替换时不需要处理DEBUG, ELOG, ERR, LOG情况的 erl 文件
-define(direct_replace_files, [
        <<"item_data">>
        ,<<"skill_data">>
        ,<<"item_gift_data">>
        ,<<"fuse_data">>
        ,<<"task_data_xx">>
        ,<<"task_data_item">>
        ,<<"super_boss_data">>
        ,<<"train_data">>
        ,<<"task_data_xiuxing">>
        ,<<"super_boss_data_casino">>
        ,<<"pet_data">>
        ,<<"map_data">>
        ,<<"boss_data">>
        ,<<"npc_data">>
        ,<<"mount_upgrade_data">>
        ,<<"task_data_drop">>
        ,<<"enchant_data">>
        ,<<"market_data_type">>
        ,<<"pet_data_gm">>
        ,<<"task_data">>
        ,<<"market_data_auto">>
        ,<<"buff_data">>
        ,<<"kw_data">>
        ,<<"npc_ai_data">>
        ,<<"guild_data">>
        ,<<"refining_data">>
        ,<<"disciple_data">>
        ,<<"map_data_elem">>
        ,<<"vip_data">>
        ,<<"casino_data">>
        ,<<"map_event_data">>
        ,<<"lottery_data">>
        ,<<"dungeon_data">>
        ,<<"drop_data">>
        ,<<"meteorolite_data">>
        ,<<"guild_aim_data">>
        ,<<"rank_data_reward">>
        ,<<"pet_data_skill">>
        ,<<"guild_skill_data">>
        ,<<"combat_data_skill">>
        ,<<"npc_store_data">>
        ,<<"npc_store_data_sm">>
        ,<<"rank_data_celebrity">>
        ,<<"guild_practise_data">>
        ,<<"npc_store_data_dung">>
        ,<<"achievement_data">>
        ,<<"achievement_data_honor">>
    ]
).
