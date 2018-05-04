%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-7-19
%% Description: TODO: Add description to cfg_mnesia

-module(cfg_mnesia).

-include("mnesia.hrl").
-include("all_pb.hrl").
-export([
         find/1,
         tab_frag/1,
         key_hash/3,
         is_inactive_storage/0,
         is_tab_inactive/1,
         tab_inactive_frag/1
        ]).

find(tab_list)->
    [#r_tab{table_name=?DB_ROLE_ID,
            copies_type=disc_copies,type=set,
            record_name=r_counter,record_fields=record_info(fields, r_counter),
            index_list=[]},
     #r_tab{table_name=?DB_ACCOUNT,
            copies_type=disc_copies,type=set,
            record_name=r_account,record_fields=record_info(fields, r_account),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_NAME,
            copies_type=disc_copies,type=set,
            record_name=r_role_name,record_fields=record_info(fields, r_role_name),
            index_list=[]},
     #r_tab{table_name=?DB_FCM_DATA,
            copies_type=disc_copies,type=set,
            record_name=r_fcm_data,record_fields=record_info(fields, r_fcm_data),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_BASE,
            copies_type=disc_copies,type=set,
            record_name=p_role_base,record_fields=record_info(fields, p_role_base),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_ATTR,
            copies_type=disc_copies,type=set,
            record_name=p_role_attr,record_fields=record_info(fields, p_role_attr),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_EXT,
            copies_type=disc_copies,type=set,
            record_name=p_role_ext,record_fields=record_info(fields, p_role_ext),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_POS,
            copies_type=disc_copies,type=set,
            record_name=r_role_pos,record_fields=record_info(fields, r_role_pos),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_STATE,
            copies_type=disc_copies,type=set,
            record_name=r_role_state,record_fields=record_info(fields, r_role_state),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_BAG,
            copies_type=disc_copies,type=set,
            record_name=r_role_bag,record_fields=record_info(fields, r_role_bag),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_BAG_BASIC,
            copies_type=disc_copies,type=set,
            record_name=r_role_bag_basic,record_fields=record_info(fields, r_role_bag_basic),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_EQUIP,
            copies_type=disc_copies,type=set,
            record_name=r_role_equip,record_fields=record_info(fields, r_role_equip),
            index_list=[]},
     #r_tab{table_name=?DB_PET_COUNTER,
            copies_type=disc_copies,type=set,
            record_name=r_counter,record_fields=record_info(fields, r_counter),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_PET,
            copies_type=disc_copies,type=set,
            record_name=r_role_pet,record_fields=record_info(fields, r_role_pet),
            index_list=[]},
     #r_tab{table_name=?DB_PET,
            copies_type=disc_copies,type=set,
            record_name=r_pet,record_fields=record_info(fields, r_pet),
            index_list=[]},
     #r_tab{table_name=?DB_PET_BAG,
            copies_type=disc_copies,type=set,
            record_name=r_pet_bag,record_fields=record_info(fields, r_pet_bag),
            index_list=[]},
     #r_tab{table_name=?DB_SYSTEM_CONFIG,
            copies_type=disc_copies,type=set,
            record_name=r_system_config,record_fields=record_info(fields, r_system_config),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_SYS_CONF,
            copies_type=disc_copies,type=set,
            record_name=r_role_sys_conf,record_fields=record_info(fields, r_role_sys_conf),
            index_list=[]},
     #r_tab{table_name=?DB_BAN_CHAT_USER,
            copies_type=disc_copies,type=set,
            record_name=r_ban_chat_user,record_fields=record_info(fields, r_ban_chat_user),
            index_list=[]},
     #r_tab{table_name=?DB_BAN_CONFIG,
            copies_type=disc_copies,type=set,
            record_name=r_ban_config,record_fields=record_info(fields, r_ban_config),
            index_list=[]},
     #r_tab{table_name=?DB_COMMON_LETTER_COUNTER,
            copies_type=disc_copies,type=set,
            record_name=r_counter,record_fields=record_info(fields, r_counter),
            index_list=[]},
     #r_tab{table_name=?DB_COMMON_LETTER,
            copies_type=disc_copies,type=set,
            record_name=r_common_letter,record_fields=record_info(fields, r_common_letter),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_LETTER,
            copies_type=disc_copies,type=set,
            record_name=r_role_letter,record_fields=record_info(fields, r_role_letter),
            index_list=[]},
     #r_tab{table_name=?DB_PAY_REQUEST,
            copies_type=disc_copies,type=set,
            record_name=r_pay_request,record_fields=record_info(fields, r_pay_request),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_MISSION,
            copies_type=disc_copies,type=set,
            record_name=r_role_mission,record_fields=record_info(fields, r_role_mission),
            index_list=[]},
     #r_tab{table_name=?DB_BROADCAST_MESSAGE,
            copies_type=disc_copies,type=set,
            record_name=r_broadcast_message,record_fields=record_info(fields, r_broadcast_message),
            index_list=[]},
     #r_tab{table_name=?DB_LIMIT_ACCOUNT,
            copies_type=disc_copies,type=set,
            record_name=r_limit_account,record_fields=record_info(fields, r_limit_account),
            index_list=[]},
     #r_tab{table_name=?DB_LIMIT_IP,
            copies_type=disc_copies,type=set,
            record_name=r_limit_ip,record_fields=record_info(fields, r_limit_ip),
            index_list=[]},
     #r_tab{table_name=?DB_LIMIT_DEVICE_ID,
            copies_type=disc_copies,type=set,
            record_name=r_limit_device_id,record_fields=record_info(fields, r_limit_device_id),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_CUSTOMER_SERVICE,
            copies_type=disc_copies,type=set,
            record_name=r_role_customer_service,record_fields=record_info(fields, r_role_customer_service),
            index_list=[]},
     #r_tab{table_name=?DB_FAMILY_COUNTER,
            copies_type=disc_copies,type=set,
            record_name=r_counter,record_fields=record_info(fields, r_counter),
            index_list=[]},
     #r_tab{table_name=?DB_FAMILY_NAME,
            copies_type=disc_copies,type=set,
            record_name=r_family_name,record_fields=record_info(fields, r_family_name),
            index_list=[]},
     #r_tab{table_name=?DB_FAMILY,
            copies_type=disc_copies,type=set,
            record_name=r_family,record_fields=record_info(fields, r_family),
            index_list=[]},
     #r_tab{table_name=?DB_FAMILY_MEMBER,
            copies_type=disc_copies,type=set,
            record_name=r_family_member,record_fields=record_info(fields, r_family_member),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_RANK,
            copies_type=disc_copies,type=set,
            record_name=r_role_rank,record_fields=record_info(fields, r_role_rank),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_SKILL,
            copies_type=disc_copies,type=set,
            record_name=r_role_skill,record_fields=record_info(fields, r_role_skill),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_BUFF,
            copies_type=disc_copies,type=set,
            record_name=r_role_buff,record_fields=record_info(fields, r_role_buff),
            index_list=[]},
     #r_tab{table_name=?DB_ROLE_FB,
            copies_type=disc_copies,type=set,
            record_name=r_role_fb,record_fields=record_info(fields, r_role_fb),
            index_list=[]},
      
     %% ets表定义
     #r_tab{table_name=?DB_ROLE_ONLINE,
            copies_type=ram_copies,type=set,
            record_name=r_role_online,record_fields=record_info(fields, r_role_online),
            index_list=[]}
    ];

%% table_name 表名
%% store_type 存储类型 ets|dist
%% load_type 加载类型 auto|custom
%% dump_type 转储类型 auto|custom
%%-record(r_role_tab,{table_name,store_type,load_type,dump_type}).

find(role_tab_list)->
    [#r_role_tab{table_name = ?DB_ROLE_BASE,               store_type = ets,  load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_ATTR,               store_type = ets,  load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_POS,                store_type = ets,  load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_STATE,              store_type = ets,  load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_EQUIP,              store_type = dict, load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_MISSION,            store_type = dict, load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_PET,                store_type = dict, load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_SKILL,              store_type = dict, load_type = costom, dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_FB,                 store_type = dict, load_type = auto,   dump_type = auto},
     
     #r_role_tab{table_name = ?DB_BAN_CHAT_USER,           store_type = dict, load_type = auto,   dump_type = auto},
     #r_role_tab{table_name = ?DB_ROLE_CUSTOMER_SERVICE,   store_type = dict, load_type = costom, dump_type = auto}
    ];

%% 玩家数据迁移到不活跃存储间隔，单位为秒
%% 1天=86400秒
%% 3天=259200秒
%% 7天=604800秒
find(move_inactive_interval) ->
    86400;
%% 定时执行数据迁移任务时间配置
%% 每天的几时几分几秒{0..23,0..59,0..59}
find(migration_time) ->
    {3,15,0};

find(_)->undefined.


%% 分表的配置
%% Tab 表名
%% frag 分表数 0表示不需要分表，只能填写2^N次方的数，如 0,2,4,8,16,32
tab_frag(?DB_ROLE_BASE) ->
    2;
tab_frag(?DB_ROLE_ATTR) ->
    2;
tab_frag(?DB_ROLE_BAG) ->
    4;
tab_frag(?DB_PET) ->
    4;
tab_frag(_Tab) ->
    0.
%% ============================================================================
%% 数据表对应的不活跃数据表配置
%% 表名_p 类型为 disc_only_copies
%% 同时支持分表
%% ============================================================================
%% 是否开启不活跃数据存储
is_inactive_storage() -> true.
%% 是否需要区分不活跃数据
%% return true | false
is_tab_inactive(?DB_ROLE_BASE) -> true;
is_tab_inactive(?DB_ROLE_ATTR) -> true;
is_tab_inactive(?DB_ROLE_POS) -> true;
is_tab_inactive(?DB_ROLE_STATE) -> true;
is_tab_inactive(?DB_ROLE_EXT) -> true;
is_tab_inactive(?DB_ROLE_BAG_BASIC) -> true;
is_tab_inactive(?DB_ROLE_BAG) -> true;
is_tab_inactive(?DB_ROLE_MISSION) -> true;
is_tab_inactive(?DB_ROLE_SYS_CONF) -> true;
is_tab_inactive(?DB_ROLE_LETTER) -> true;
is_tab_inactive(?DB_ROLE_CUSTOMER_SERVICE) -> true;
is_tab_inactive(?DB_ROLE_SKILL) -> true;
is_tab_inactive(?DB_ROLE_BUFF) -> true;
is_tab_inactive(?DB_ROLE_FB) -> true;
is_tab_inactive(?DB_ROLE_PET) -> true;
is_tab_inactive(?DB_PET_BAG) -> true;
is_tab_inactive(?DB_PET) -> true;

is_tab_inactive(?DB_PAY_REQUEST) -> true;

is_tab_inactive(_Tab) -> false.

%% 不活跃数据表，分区表数配置
%% Tab 表名
%% frag 分表数 0表示不需要分表，只能填写2^N次方的数，如 0,2,4,8,16,32
tab_inactive_frag(?DB_ROLE_BASE) ->
    2;
tab_inactive_frag(?DB_ROLE_ATTR) ->
    2;
tab_inactive_frag(?DB_ROLE_BAG) ->
    4;
tab_inactive_frag(?DB_PET) ->
    4;
tab_inactive_frag(?DB_PAY_REQUEST) ->
    2;
tab_inactive_frag(_Tab) ->
    0.



%% 获取Key存放的分表索引
-spec
key_hash(Tab,Key,Range) -> Frag when
    Tab :: atom(),
    Key :: term(),
    Range :: integer(),
    Frag :: integer().
key_hash(?DB_ROLE_BASE,Key,Range) ->
    key_hash_by_rem(Key,Range);
key_hash(?DB_ROLE_ATTR,Key,Range) ->
    key_hash_by_rem(Key,Range);
key_hash(?DB_ROLE_BAG,{RoleId,_BagId},Range) ->
    key_hash_by_rem(RoleId,Range);
key_hash(?DB_PET_BAG,{RoleId,_BagId},Range) ->
    key_hash_by_rem(RoleId,Range);
key_hash(?DB_PET,Key,Range) ->
    key_hash_by_rem(Key,Range);
key_hash(_Tab,Key,Range) ->
    erlang:phash(Key, Range).

%% 取余算法hash处理
key_hash_by_rem(Key,Range) when erlang:is_integer(Key) ->
    Frag = Key rem Range,
    if Frag == 0 ->
           Range;
       true ->
           Frag
    end;
key_hash_by_rem(Key,Range) ->
    erlang:phash(Key, Range).
