%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 十月 2015 10:34
%%%-------------------------------------------------------------------
-module(t_guild).
-author("hxming").
-include("common.hrl").
-include("guild.hrl").
%% API
-compile(export_all).

log_msg(Type) ->
    case Type of
        1 ->
            ?T("~s创建了仙盟");
        2 ->
            ?T("~s加入仙盟");
        3 ->
            ?T("~s退出仙盟");
        4 ->
            ?T("~s被移出仙盟");
        5 ->
            ?T("~s修改仙盟公告为：~s");
        6 ->
            ?T("~s转让会长职位给~s");
        7 ->
            ?T("任命~s为掌教");
        8 ->
            ?T("任命~s为长老");
        9 ->
            ?T("任命~s为掌门");
        10 ->
            ?T("~s发起弹劾掌门申请");
        11 ->
            ?T("~s发起弹劾成功成为新一届掌门");
        12 ->
            ?T("~s成为新一届会长");
        _ -> <<>>
    end.

guild_mail(Type) ->
    case Type of
        100 ->
            ?T("您所在的仙盟活跃度不足2000，如果活跃度扣除到0，仙盟将解散");
        _ -> <<>>
    end.

notice() ->
    io_lib:format("~s",[?T("欢迎大家加入仙盟，文明游戏，快乐竞技！")]).

get_guild_pos_name(Pos) ->
    case Pos of
        ?GUILD_POSITION_CHAIRMAN -> ?T("掌门");
        ?GUILD_POSITION_VICE_CHAIRMAN -> ?T("掌教");
        ?GUILD_POSITION_ELDER -> ?T("长老");
        ?GUILD_POSITION_GS -> ?T("管事");
        ?GUILD_POSITION_NORMAL -> ?T("弟子")
    end.
