%% @filename merge_migration.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-02 
%% @doc 
%% 数据合并.
%% 数据合并到临时主数据库 xxx_tmp 表

-module(merge_migration).

-include("common.hrl").
-include("merge.hrl").


-export([do/1]).

%% 数据合并
-spec do(ServerId) -> ok when ServerId :: integer().
do(ServerId) ->
    %% 帐号处理，重复帐号处理
    do_duplicate_account(ServerId),
    %% 处理数据库UUID数据
    do_unique_id(ServerId),
    %% 保留主服数据
    do_hold_master(ServerId),
    %% 是否开启开启名字后缀，如果没有开启即需要处理重名
    case ?IS_NAME_SUFFIX of
        false ->
            do_name_suffix(ServerId);
        _ ->
            next
    end,
    %% 合并数据
    do_merge_data(ServerId),
    ok.

%% 帐号处理，重复帐号处理
-spec do_duplicate_account(ServerId) -> ok when ServerId :: integer().
do_duplicate_account(ServerId) ->
    Tab = ?DB_ACCOUNT,
    TabList = db_misc:get_all_tab(Tab),
    AccountTabList = [merge_misc:get_merge_table_name(T, ServerId) || T <- TabList],
    AccountTabFunc = 
        fun(#r_account{account_name=AccountName, role_list=AddRoleList} = AddAccount ) ->
                case dirty_all_read(?DB_ACCOUNT, AccountName) of
                    [] ->
                        dirty_all_write(?DB_ACCOUNT, AddAccount),
                        ok;
                    [#r_account{role_list = RoleList} = Account ] ->
                        NewRoleList = AddRoleList ++ RoleList,
                        dirty_all_write(?DB_ACCOUNT,Account#r_account{role_num = erlang:length(NewRoleList),role_list=NewRoleList}),
                        ok
                end
        end,
    do_each_dirty_read(AccountTabList,AccountTabFunc),
    ok.
%% 处理数据库UUID数据
-spec do_unique_id(ServerId) -> ok when ServerId :: integer().
do_unique_id(ServerId) -> 
    TabList = [
               ?DB_ROLE_ID,
               ?DB_PET_COUNTER,
               ?DB_FAMILY_COUNTER
               ],
    do_merge_record(TabList,ServerId).
    
%% 保留主服数据
-spec do_hold_master(ServerId) -> ok when ServerId :: integer().
do_hold_master(ServerId) ->
    TabList = [
               ?DB_SYSTEM_CONFIG,
               ?DB_BROADCAST_MESSAGE
               ],
    [ServerIdList] = common_config_dyn:find(merge, server_id_list),
    [MasterServerId | _] = ServerIdList,
    case MasterServerId == ServerId of
        true -> 
            do_merge_record(TabList,ServerId);
        _ ->
            ok
    end.

%% 如果系统没有开启名称后缀，即需要处理重名问题
%% 即把重名的自己添加后缀 merge.rename_postfix
-spec do_name_suffix(ServerId) -> ok when ServerId :: integer().
do_name_suffix(ServerId) ->
    RoleRenameList = get_role_rename(ServerId),
    %% 玩家改名
    ok = do_role_rename(RoleRenameList,ServerId),
    FamilyRenameList = get_family_rename(ServerId),
    %% 帮派改名
    ok = do_family_rename(FamilyRenameList,ServerId),
    %% 特殊表改名，即帮派表处理
    ok = do_family_table_rename(RoleRenameList,FamilyRenameList,ServerId),
    ok.
%% 需要改名的玩家数据列表 [{RoleId,RoleName,NewRoleName},...]
get_role_rename(ServerId) ->
    Tab = ?DB_ROLE_NAME,
    TabList = db_misc:get_all_tab(Tab),
    RoleNameTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- TabList],
    get_role_rename(RoleNameTabList,ServerId,[]).
get_role_rename([],_ServerId,DataList) -> DataList; 
get_role_rename([Tab | RoleNameTabList],ServerId,DataList) ->
    NewDataList = get_role_rename2(Tab,ServerId,DataList),
    get_role_rename(RoleNameTabList,ServerId,NewDataList).
get_role_rename2(Tab,ServerId,DataList) -> 
    FirstKey = mnesia:dirty_first(Tab),
    get_role_rename2(FirstKey,Tab,ServerId,DataList).
get_role_rename2('$end_of_table',_Tab,_ServerId,DataList) -> DataList;
get_role_rename2(Key,Tab,ServerId,DataList) ->
    case dirty_all_read(?DB_ROLE_NAME, Key) of
        [] ->
            NewDataList = DataList;
        _ ->
            [#r_role_name{role_id=RoleId}] = mnesia:dirty_read(Tab, Key),
            NewName = merge_misc:get_real_name(Key, ServerId),
            NewDataList = [{RoleId,Key,NewName} | DataList]
    end,
    NextKey = mnesia:dirty_next(Tab,Key),
    get_role_rename2(NextKey,Tab,ServerId,NewDataList).

do_role_rename([],_ServerId) -> ok;
do_role_rename([ {RoleId,RoleName,NewRoleName} | DataList],ServerId) ->
    do_role_rename(RoleId,RoleName,NewRoleName,ServerId),
    do_role_rename(DataList,ServerId).

%% 玩家改名操作
do_role_rename(RoleId,RoleName,NewRoleName,ServerId) ->
    %% DB_ROLE_NAME 玩家名称表
    RoleNameTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- db_misc:get_all_tab(?DB_ROLE_NAME)],
    RoleNameTabFunc =
        fun(Tab,#r_role_name{role_id=PRoleId} = R) ->
                case PRoleId of
                    RoleId ->
                        NR = R#r_role_name{role_name=NewRoleName},
                        mnesia:dirty_write(Tab, NR);
                    _ ->
                        next
                end
        end,
    do_dirty_read(RoleNameTabList,RoleName,RoleNameTabFunc),
    %% DB_ROLE_BASE 玩家基础数据
    RoleBaseTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- db_misc:get_all_tab(?DB_ROLE_BASE)],
    RoleBaseTabFunc = 
        fun(Tab,#p_role_base{role_id=PRoleId} = R) ->
                case PRoleId of
                    RoleId ->
                        NR = R#p_role_base{role_name=NewRoleName},
                        mnesia:dirty_write(Tab, NR);
                    _ ->
                        next
                end
        end,
    do_dirty_read(RoleBaseTabList,RoleId,RoleBaseTabFunc),
    %% DB_ROLE_LETTER 玩家信件表
    RoleLetterTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- db_misc:get_all_tab(?DB_ROLE_LETTER)],
    RoleLetterTabFunc = 
        fun(Tab,#r_role_letter{role_id=PRoleId} = R) ->
                case PRoleId of
                    RoleId ->
                        NR = R#r_role_letter{role_name=NewRoleName},
                        mnesia:dirty_write(Tab, NR);
                    _ ->
                        next
                end
        end,
    do_dirty_read(RoleLetterTabList,RoleId,RoleLetterTabFunc),
    %% DB_BAN_CHAT_USER 禁言表
    BanChatUserTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- db_misc:get_all_tab(?DB_BAN_CHAT_USER)],
    BanChatUserTabFunc = 
        fun(Tab,#r_ban_chat_user{role_id=PRoleId} = R) ->
                case PRoleId of
                    RoleId ->
                        NR = R#r_ban_chat_user{role_name=NewRoleName},
                        mnesia:dirty_write(Tab, NR);
                    _ ->
                        next
                end
        end,
    do_dirty_read(BanChatUserTabList,RoleId,BanChatUserTabFunc),
    %% DB_ROLE_RANK 角色榜
    RoleRankTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- db_misc:get_all_tab(?DB_ROLE_RANK)],
    RoleRankTabFunc =
        fun(Tab,#r_role_rank{role_id=PRoleId} = R) ->
                case PRoleId of
                    RoleId ->
                        NR = R#r_role_rank{role_name=NewRoleName},
                        mnesia:dirty_write(Tab, NR);
                    _ ->
                        next
                end
        end,
    do_dirty_read(RoleRankTabList,RoleId,RoleRankTabFunc),
    %% TODO 增加其它需要修改角色名称的处理
    ok.

%% 需要改名的帮派数据列表 [{FamilyId,FamilyName,NewFamilyName},...]
get_family_rename(ServerId) ->
    Tab = ?DB_FAMILY_NAME,
    TabList = db_misc:get_all_tab(Tab),
    FamilyNameTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- TabList],
    get_family_rename(FamilyNameTabList,ServerId,[]).
get_family_rename([],_ServerId,DataList) -> DataList; 
get_family_rename([Tab | FamilyNameTabList],ServerId,DataList) ->
    NewDataList = get_family_rename2(Tab,ServerId,DataList),
    get_family_rename(FamilyNameTabList,ServerId,NewDataList).

get_family_rename2(Tab,ServerId,DataList) -> 
    FirstKey = mnesia:dirty_first(Tab),
    get_family_rename2(FirstKey,Tab,ServerId,DataList).
get_family_rename2('$end_of_table',_Tab,_ServerId,DataList) -> DataList;
get_family_rename2(Key,Tab,ServerId,DataList) ->
    case dirty_all_read(?DB_FAMILY_NAME, Key) of
        [] ->
            NewDataList = DataList;
        _ ->
            [#r_family_name{family_name=FamilyName, family_id=FamilyId}] = mnesia:dirty_read(Tab, Key),
            NewName = merge_misc:get_real_name(Key, ServerId),
            NewDataList = [{FamilyId,FamilyName,NewName} | DataList]
    end,
    NextKey = mnesia:dirty_next(Tab,Key),
    get_family_rename2(NextKey,Tab,ServerId,NewDataList).
%% 执行帮派改名
do_family_rename([],_ServerId) -> ok;
do_family_rename([ {FamilyId,FamilyName,NewName} | DataList],ServerId) ->
    do_family_rename(FamilyId,FamilyName,NewName,ServerId),
    do_family_rename(DataList,ServerId).

do_family_rename(FamilyId,FamilyName,NewName,ServerId) ->
    %% DB_FAMILY_NAME 帮派名称表
    FamilyNameTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- db_misc:get_all_tab(?DB_FAMILY_NAME)],
    FamilyNameTabFunc =
        fun(Tab,#r_family_name{family_id=PFamilyId} = R) ->
                case PFamilyId of
                    FamilyId ->
                        NR = R#r_family_name{family_name=NewName},
                        mnesia:dirty_write(Tab, NR);
                    _ ->
                        next
                end
        end,
    do_dirty_read(FamilyNameTabList,FamilyName,FamilyNameTabFunc),
    %% TODO 增加需要修改帮派名称的处理
    ok.

%% 特殊表改名，即帮派表处理
do_family_table_rename(RoleRenameList,FamilyRenameList,ServerId) ->
    FamilyTabList = [ merge_misc:get_merge_table_name(T, ServerId) || T <- db_misc:get_all_tab(?DB_FAMILY)],
    FamilyTabFunc =
        fun(Tab,#r_family{family_id=PFamilyId,create_role_id=CreateRoleId,owner_role_id=OwnerRoleId,
                          member_list=MemberList,request_list=RequestList} = R) ->
                case lists:keyfind(PFamilyId, 1, FamilyRenameList) of
                    {PFamilyId,_,FamilyName} ->
                        FR = R#r_family{family_name=FamilyName};
                    _ ->
                        FR = R
                end,
                case lists:keyfind(CreateRoleId, 1, RoleRenameList) of
                    {CreateRoleId,_,CreateRoleName} ->
                        CR = FR#r_family{create_role_name=CreateRoleName};
                    _ ->
                        CR = FR
                end,
                case lists:keyfind(OwnerRoleId, 1, RoleRenameList) of
                    {OwnerRoleId,_,OwnerRoleName} ->
                        OR = CR#r_family{owner_role_name=OwnerRoleName};
                    _ ->
                        OR = CR
                end,
                NewRequestList = 
                    [begin 
                         case lists:keyfind(RequestRoleId, 1, RoleRenameList) of
                             {RequestRoleId,_,RequestRoleName} ->
                                 RequestInfo#r_family_request{role_name = RequestRoleName};
                             _ ->
                                 RequestInfo
                         end
                     end || #r_family_request{role_id=RequestRoleId} = RequestInfo <- RequestList],
                NewMemberList = 
                    [begin
                         case lists:keyfind(MemberRoleId, 1, RoleRenameList) of
                             {MemberRoleId,_,MemberRoleName} ->
                                 MemberInfo#r_family_member{role_name = MemberRoleName};
                             _ ->
                                 MemberInfo
                         end
                     end || #r_family_member{role_id=MemberRoleId} = MemberInfo <- MemberList],
                NewR = OR#r_family{member_list = NewMemberList, request_list = NewRequestList},
                mnesia:dirty_write(Tab, NewR)
        end,
    do_dirty_read(FamilyTabList,FamilyTabFunc),
    ok.
    
%% 合并帐号为key的表的数据
do_merge_data(ServerId) ->
    %% TODO 增加需要合并数据的表
    TabList = [
               ?DB_ROLE_NAME,
               ?DB_ROLE_BASE,
               ?DB_ROLE_ATTR,
               ?DB_ROLE_POS,
               ?DB_ROLE_EXT,
               ?DB_ROLE_STATE,
               ?DB_ROLE_MISSION,
               ?DB_ROLE_SYS_CONF,
               ?DB_ROLE_SKILL,
               ?DB_ROLE_BUFF,
               ?DB_ROLE_FB,
               ?DB_ROLE_BAG_BASIC,
               ?DB_ROLE_BAG,
               
               ?DB_ROLE_PET,
               ?DB_PET_BAG,
               ?DB_PET,
               
               ?DB_ROLE_LETTER,
               ?DB_BAN_CHAT_USER,
               ?DB_ROLE_CUSTOMER_SERVICE,
               
               ?DB_PAY_REQUEST,
               
               ?DB_LIMIT_ACCOUNT,
               ?DB_LIMIT_IP,
               ?DB_LIMIT_DEVICE_ID,
               
               ?DB_FAMILY_NAME,
               ?DB_FAMILY,
               ?DB_FAMILY_MEMBER,
               
               ?DB_FCM_DATA
               ],
    do_merge_record(TabList,ServerId).

%% 合并记录
do_merge_record([],_ServerId) -> ok;
do_merge_record([Tab | TabList],ServerId) ->
    AllTabList = db_misc:get_all_tab(Tab),
    do_merge_record2(AllTabList,ServerId),
    do_merge_record(TabList,ServerId).
do_merge_record2([],_ServerId) -> ok;
do_merge_record2([Tab|TabList],ServerId) ->
    SrcTab = merge_misc:get_merge_table_name(Tab, ServerId),
    %% 转换成临时主数据库表名
    TempTab = merge_misc:get_merge_table_temp_name(Tab),
    merge_misc:do_migration_record(SrcTab, TempTab),
    do_merge_record2(TabList,ServerId).
  
%% 读取表数据并执行操作 fun(Tab,Record)
do_dirty_read([],_Key,_Func) -> ok;
do_dirty_read([ Tab | TabList],Key,Func) ->
    case mnesia:dirty_read(Tab, Key) of
        [Record] ->
            Func(Tab,Record),
            do_dirty_read([],Key,Func);
        _ ->
            do_dirty_read(TabList,Key,Func)
    end.
%% 循环每次读取一记录，并执行操作 fun(Tab,Record)
do_dirty_read([],_Func) -> ok;
do_dirty_read([ Tab | TabList],Func) ->
    FirstKey = mnesia:dirty_first(Tab),
    ok = do_dirty_read2(FirstKey,Tab,Func),
    do_dirty_read(TabList,Func).
do_dirty_read2('$end_of_table',_Tab,_Func) -> ok;
do_dirty_read2(Key,Tab,Func) ->
    [KeyRecord] = mnesia:dirty_read(Tab,Key),
    Func(Tab,KeyRecord),
    NextKey = mnesia:dirty_next(Tab,Key),
    do_dirty_read2(NextKey,Tab,Func).

    
%% 循环每次读取一记录，并执行操作 fun(Record)
do_each_dirty_read([],_Func) -> ok;
do_each_dirty_read([ Tab | TabList],Func) ->
    FirstKey = mnesia:dirty_first(Tab),
    ok = do_each_dirty_read2(FirstKey,Tab,Func),
    do_each_dirty_read(TabList,Func).
do_each_dirty_read2('$end_of_table',_SrcTabName,_Func) -> ok;
do_each_dirty_read2(Key,SrcTabName,Func) ->
    [KeyRecord] = mnesia:dirty_read(SrcTabName,Key),
    Func(KeyRecord),
    NextKey = mnesia:dirty_next(SrcTabName,Key),
    do_each_dirty_read2(NextKey,SrcTabName,Func).


%% 脏读数据，自动区分活跃表和不活跃表
-spec
dirty_all_read(Tab, Key) -> ValueList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    ValueList :: [] | [term()],
    Reason :: term().
dirty_all_read(Tab, Key) ->
    case cfg_mnesia:is_inactive_storage() == true andalso cfg_mnesia:is_tab_inactive(Tab) == true of
        true ->
            case active_dirty_read(Tab, Key) of
                [Value] ->
                    [Value];
                _ ->
                    inactive_dirty_read(Tab, Key)
            end;
        _ ->
            active_dirty_read(Tab, Key)
    end.
%% mnesia:dirty_read/2
-spec
active_dirty_read(Tab, Key) -> ValueList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    ValueList :: [] | [term()],
    Reason :: term().
active_dirty_read(Tab, Key) ->
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    %% 转换成临时主数据库表名
    TempTab = merge_misc:get_merge_table_temp_name(NewTab),
    mnesia:dirty_read(TempTab, Key).
%% mnesia:dirty_read/2
-spec
inactive_dirty_read(Tab, Key) -> ValueList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    ValueList :: [] | [term()],
    Reason :: term().
inactive_dirty_read(Tab, Key) ->
    NewTab = db_misc:gen_inactive_tab_name(Tab,Key),
    %% 转换成临时主数据库表名
    TempTab = merge_misc:get_merge_table_temp_name(NewTab),
    mnesia:dirty_read(TempTab, Key).


%% 脏写数据，自动区分活跃表和不活跃表
-spec
dirty_all_write(Tab, Record) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Record :: term(),
    Reason :: term().
dirty_all_write(Tab, Record) ->
    case cfg_mnesia:is_inactive_storage() == true andalso cfg_mnesia:is_tab_inactive(Tab) == true of
        true ->
            Key = erlang:element(2,Record),
            NewTab = db_misc:gen_active_tab_name(Tab,Key),
            %% 转换成临时主数据库表名
            TempTab = merge_misc:get_merge_table_temp_name(NewTab),
            case mnesia:dirty_read(TempTab, Key) of
                [_Value] ->
                    mnesia:dirty_write(TempTab, Record);
                _ ->
                    inactive_dirty_write(Tab, Record)
            end;
        _ ->
            active_dirty_write(Tab, Record)
    end.

%% mnesia:dirty_write/2
-spec
active_dirty_write(Tab, Record) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Record :: term(),
    Reason :: term().
active_dirty_write(Tab, Record) ->
    Key = erlang:element(2,Record),
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    %% 转换成临时主数据库表名
    TempTab = merge_misc:get_merge_table_temp_name(NewTab),
    mnesia:dirty_write(TempTab, Record).
%% mnesia:dirty_write/2
-spec
inactive_dirty_write(Tab, Record) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Record :: term(),
    Reason :: term().
inactive_dirty_write(Tab, Record) ->
    Key = erlang:element(2,Record),
    NewTab = db_misc:gen_inactive_tab_name(Tab,Key),
    %% 转换成临时主数据库表名
    TempTab = merge_misc:get_merge_table_temp_name(NewTab),
    mnesia:dirty_write(TempTab, Record).