%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 开服活动之帮派争霸
%%% @end
%%% Created : 28. 三月 2017 15:45
%%%-------------------------------------------------------------------
-module(open_act_guild_rank).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("guild.hrl").

%% API
-export([
    sys_midnight_cacl/0,
    get_act/0,

    get_act_info/0,
    gm_reward/0, %% 手动发放奖励
    get_state/1
]).

get_act_info() ->
    case get_act() of
        [] ->
            {0, []};
        #base_open_act_guild_rank{list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            L = lists:map(fun(T) -> tuple_to_list(T) end, BaseList),
            {LTime, L}
    end.

%% 凌晨邮件结算
sys_midnight_cacl() ->
    {{_Y, _M, _D}, {H, Min, _S}} = erlang:localtime(),
    if
        H == 23 andalso Min == 58 -> sys_midnight_cacl2(_Y, _M, _D);
        true -> ok
    end.

gm_reward() ->
    {{_Y, _M, _D}, {_H, _Min, _S}} = erlang:localtime(),
    sys_midnight_cacl2(_Y, _M, _D).

sys_midnight_cacl2(Y, M, D) ->
    case get_act() of
        [] ->
            ok;
        #base_open_act_guild_rank{list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            IsCenter = config:is_center_node(),
            if
                LTime > 150 -> skip;
                IsCenter == true -> skip;
                true ->
                    spawn(fun() -> timer:sleep(150000), sys_midnight_cacl3(BaseList, Y, M, D) end)
            end
    end.

sys_midnight_cacl3(BaseList, Y, M, D) ->
    case guild_util:get_guild_rank_1() of
        [] ->
            skip;
        GuildList ->
            F = fun({Rank, MemberType, GiftId}) ->
                if
                    length(GuildList) < Rank -> skip;
                    true ->
                        Guild = lists:nth(Rank, GuildList),
                        Pkey = Guild#guild.pkey,
                        Gkey = Guild#guild.gkey,
                        case MemberType of
                            1 ->  %% 发帮主奖励
                                {Title0, Content0} = t_mail:mail_content(67),
                                Title = io_lib:format(Title0, [get_str(Rank)]),
                                TimeStr = util:unixtime_to_time_string4(util:unixtime()),
                                case version:get_lan_config() of
                                    vietnam ->
                                        Content = io_lib:format(Content0, [Guild#guild.name, TimeStr, get_str(Rank)]);
                                    _ ->
                                        Content = io_lib:format(Content0, [Guild#guild.name, Y, M, D, get_str(Rank)])
                                end,
                                mail:sys_send_mail([Pkey], Title, Content, [{GiftId, 1}]);
                            2 -> %% 给所有成员发奖励
                                Rand = util:rand(1000, 15000),
                                timer:sleep(2000 + Rand),
                                MemberList = guild_ets:get_guild_member_list(Gkey),
                                F2 = fun(#g_member{pkey = MemberPkey}) ->
                                    {Title0, Content0} = t_mail:mail_content(68),
                                    Title = io_lib:format(Title0, [get_str(Rank)]),
                                    TimeStr = util:unixtime_to_time_string4(util:unixtime()),
                                    case version:get_lan_config() of
                                        vietnam ->
                                            Content = io_lib:format(Content0, [Guild#guild.name, TimeStr, get_str(Rank)]);
                                        _ ->
                                            Content = io_lib:format(Content0, [Guild#guild.name, Y, M, D, get_str(Rank)])
                                    end,
                                    mail:sys_send_mail([MemberPkey], Title, Content, [{GiftId, 1}])
                                end,
                                lists:map(F2, MemberList)
                        end
                end
            end,
            lists:map(F, BaseList)
    end.

get_str(1) ->
    ?T("一");
get_str(2) ->
    ?T("二");
get_str(3) ->
    ?T("三");
get_str(4) ->
    ?T("四");
get_str(5) ->
    ?T("五");
get_str(_) ->
    "".

get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        _ ->
            0
    end.

get_act() ->
    case activity:get_work_list(data_open_guild_rank) of
        [] -> [];
        [Base | _] -> Base
    end.
