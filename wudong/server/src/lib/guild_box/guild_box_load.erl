%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 十二月 2017 10:50
%%%-------------------------------------------------------------------
-module(guild_box_load).
-author("Administrator").
-include("guild.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    load_all_guild_box/0,
    load_player_data/1,
    timer_delete/0,
    update_player_data/1,
    update_guild_box/1]).

timer_delete() ->
    Now = util:unixtime(),
    Sql = io_lib:format("DELETE  FROM guild_box WHERE  ~p - end_time > ~p", [Now, ?ONE_DAY_SECONDS * 3]),
    db:execute(Sql),
    ok.

load_all_guild_box() ->
    Sql = io_lib:format("select box_key,pkey,pname,gkey,start_time,end_time,base_id,help_list,reward_list,is_open from guild_box", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([BoxKey, Pkey, Pname, Gkey, StartTime, EndTime, BaseId, HelpListBin, RewardListBin, IsOpen]) ->
                HelpList = util:bitstring_to_term(HelpListBin),
                RewardList = util:bitstring_to_term(RewardListBin),
                GuildBox =
                    #guild_box{
                        box_key = BoxKey, %% 宝箱key
                        pkey = Pkey,
                        pname = Pname,
                        gkey = Gkey,
                        start_time = StartTime,
                        end_time = EndTime,
                        base_id = BaseId,
                        help_list = HelpList,
                        reward_list = RewardList,
                        is_open = IsOpen
                    },
                GuildBox
            end,
            lists:map(F, Rows)
    end.

update_guild_box(GuildBox) ->
    #guild_box{
        box_key = BoxKey, %% 宝箱key
        pkey = Pkey,
        pname = Pname,
        gkey = Gkey,
        start_time = StartTime, %% 宝箱创建时间
        end_time = EndTime, %% 宝箱结束时间
        base_id = BaseId, %% 宝箱配表ID
        help_list = HelpList, %% 协助列表[{Pkey,Pname}]
        reward_list = RewardList, %% 奖励列表
        is_open = IsOpen %% 0未被领取 1已被领取
    } = GuildBox,
    HelpListBin = util:term_to_bitstring(HelpList),
    RewardListBin = util:term_to_bitstring(RewardList),
    Sql = io_lib:format("replace into guild_box set box_key=~p,pkey=~p,pname='~s',gkey=~p,start_time=~p,end_time=~p,base_id=~p,help_list='~s',reward_list='~s',is_open=~p",
        [BoxKey, Pkey, Pname, Gkey, StartTime, EndTime, BaseId, HelpListBin, RewardListBin, IsOpen]),
    db:execute(Sql),
    ok.

load_player_data(Pkey) ->
    Sql = io_lib:format("select get_cd,is_get_cd,help_cd,is_help_cd,index_id,index_count from player_guild_box where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [GetCd, IsGetCd0, HelpCd, IsHelpCd0, IndexId, IndexCount] ->
            Now = util:unixtime(),
            IsGetCd = ?IF_ELSE(GetCd < Now, 0, IsGetCd0),
            IsHelpCd = ?IF_ELSE(HelpCd < Now, 0, IsHelpCd0),
            #player_guild_box{
                pkey = Pkey,
                get_cd = GetCd,
                is_get_cd = IsGetCd,
                help_cd = HelpCd,
                is_help_cd = IsHelpCd,
                index_id = IndexId,
                index_count = IndexCount
            };
        _ ->
            #player_guild_box{
                pkey = Pkey
            }
    end.

update_player_data(#player_guild_box{pkey = Pkey, get_cd = GetCd, is_get_cd = IsGetCd, help_cd = HelpCd, is_help_cd = IsHelpCd, index_id = IndexId, index_count = IndexCount}) ->
    Sql = io_lib:format("replace into player_guild_box set  pkey=~p,get_cd=~p,is_get_cd=~p,help_cd=~p,is_help_cd=~p,index_id =~p,index_count = ~p ",
        [Pkey, GetCd, IsGetCd, HelpCd, IsHelpCd, IndexId, IndexCount]),
    db:execute(Sql),
    ok.