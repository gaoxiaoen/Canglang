%%----------------------------------------------------
%% 七夕送花排行榜活动
%% @author lishen(105326073@qq.com)
%%----------------------------------------------------
-module(rank_qixi).

-export([
        startup_qixi/0
        ,handle_qixi/2
        ,reward/0
    ]).
-include("common.hrl").
-include("rank.hrl").

-define(start_date, {{2013,2,12},{0,0,1}}). %% 活动2 - 2/12 -2/16
-define(end_date, {{2013,2,16},{23,59,59}}).

%%----------------------------------------------------
%% 外部接口
%%----------------------------------------------------
%% @spec startup_qixi() -> ok.
%% @doc 开启七夕送花活动
startup_qixi() ->
    Now = util:unixtime(),
    case {util:datetime_to_seconds(?start_date), util:datetime_to_seconds(?end_date)} of
        {false, _} ->
            ?DEBUG("qixi DateTime error!");
        {_, false} ->
            ?DEBUG("qixi DateTime error!");
        {StartSecondsTime, EndSecondsTime} when Now < EndSecondsTime ->
            ?DEBUG("qixi datetime_to_seconds suc! SecondsTime = ~w", [StartSecondsTime]),
            case StartSecondsTime > Now of
                true ->
                    erlang:send_after((StartSecondsTime - Now) * 1000, self(), qixi_flower);
                false ->
                    erlang:send_after(10 * 60 * 1000, self(), qixi_flower)
            end;
        _ ->
            ?DEBUG("qixi over"),
            Rank1 = rank_mgr:lookup(?rank_flower_day),
            Rank2 = rank_mgr:lookup(?rank_glamor_day),
            rank_mgr:update_ets(Rank1#rank{honor_roles = []}),
            rank_mgr:update_ets(Rank2#rank{honor_roles = []})
    end.

%% @spec handle_qixi(Rank, Type) -> ok | ignore.
%% Rank = #rank{}
%% Type = integer() 排行榜类型
%% @doc 处理七夕送花活动
handle_qixi(#rank{roles = []}, _Type) -> ignore;
handle_qixi(Rank = #rank{honor_roles = OldHonorL, roles = RankList}, Type) ->
    First = lists:nth(1, RankList),
    case get_role_info(First) of
        {Rid, Name, Sex, _} ->
            qixi_broadcast(Rid, Name, Sex, Type),
            NewHonorL = rank_reward:update_honor(Type, OldHonorL, [{Rid, Sex}]),
            rank_mgr:update_ets(Rank#rank{honor_roles = NewHonorL});
        false ->
            ok
    end.

%% @spec reward() -> ok.
%% @doc 奖励发放
reward() ->
    Now = util:unixtime(),
    case {util:datetime_to_seconds(?start_date), util:datetime_to_seconds(?end_date)} of
        {false, _} ->
            ?DEBUG("qixi DateTime error!");
        {_, false} ->
            ?DEBUG("qixi DateTime error!");
        {StartSecondsTime, EndSecondsTime} when Now > StartSecondsTime andalso Now < EndSecondsTime ->
            reward(?rank_flower_day),
            reward(?rank_glamor_day),
            reward(?rank_cross_flower),
            reward(?rank_cross_glamor);
        _ ->
            ignore
    end.

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
%% 本服排行榜称号获得公告
qixi_broadcast({Id, SrvId}, Name, Sex, Type) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    notice:send(53, util:fbin(qixi_lang(Sex, Type), [Info])).

%% 获取公告内容
qixi_lang(0, ?rank_flower_day) -> ?L(<<"~s洒脱无双，赠送鲜花无数，获得至尊花痴称号，令人羡慕不已！">>);
qixi_lang(1, ?rank_flower_day) -> ?L(<<"~s洒脱无双，赠送鲜花无数，获得至尊情圣称号，令人羡慕不已！">>);
qixi_lang(0, ?rank_glamor_day) -> ?L(<<"~s魅力无限，获赠鲜花无数，获得绝代佳人称号，令人羡慕不已！">>);
qixi_lang(1, ?rank_glamor_day) -> ?L(<<"~s魅力无限，获赠鲜花无数，获得翩翩君子称号，令人羡慕不已！">>).

%% 奖励信件处理
reward(Type) ->
    #rank{roles = L} = rank_mgr:lookup(Type),
    do_reward(Type, 1, L).
do_reward(_Type, _Sort, []) -> ok;
do_reward(Type, Sort, [I | T]) ->
    case get(Type, Sort) of
        {ok, #rank_reward_base{items = Items, subject = Subject, content = Content}} ->
            case get_role_info(I) of
                {{Rid, SrvId}, Name, _, Num} when Num >= 99 ->
                    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items}),
                    do_reward(Type, Sort + 1, T);
                false ->
                    do_reward(Type, Sort + 1, T);
                _ ->
                    ok
            end;
        _ ->
            ok
    end.
            
%% 获取相关榜角色数据
get_role_info(#rank_flower_day{id = Id, name = Name, sex = Sex, flower = F}) -> {Id, Name, Sex, F};
get_role_info(#rank_glamor_day{id = Id, name = Name, sex = Sex, glamor = G}) -> {Id, Name, Sex, G};
get_role_info(#rank_cross_flower{id = Id = {_Rid, SrvId}, name = Name, sex = Sex, flower = F}) -> 
    case role_api:is_local_role(SrvId) of
        true ->
            {Id, Name, Sex, F};
        false ->
            false
    end;
get_role_info(#rank_cross_glamor{id = Id = {_Rid, SrvId}, name = Name, sex = Sex, glamor = G}) ->
    case role_api:is_local_role(SrvId) of
        true ->
            {Id, Name, Sex, G};
        false ->
            false
    end;
get_role_info(#rank_flower_acc{id = Id, name = Name, flower = F, date = Date}) -> {Id, Name, F, Date};
get_role_info(_) -> false.

%% 获取奖励信件数据
get(?rank_flower_day, Sort) when Sort =:= 1 ->
    {ok, #rank_reward_base{
            items = [{29240, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在本服今日送花榜排名第~w名，获得了【玫瑰礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(?rank_flower_day, Sort) when Sort >= 2 andalso Sort =< 3 ->
    {ok, #rank_reward_base{
            items = [{29241, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在本服今日送花榜排名第~w名，获得了【玫瑰礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(?rank_glamor_day, Sort) when Sort =:= 1 ->
    {ok, #rank_reward_base{
            items = [{29240, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在本服今日魅力榜排名第~w名，获得了【玫瑰礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(?rank_glamor_day, Sort) when Sort >= 2 andalso Sort =< 3 ->
    {ok, #rank_reward_base{
            items = [{29241, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在本服今日魅力榜排名第~w名，获得了【玫瑰礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(?rank_cross_flower, Sort) when Sort =:= 1 ->
    {ok, #rank_reward_base{
            items = [{29234, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在跨服飞仙情圣榜排名第~w名，获得了【魅力礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(?rank_cross_flower, Sort) when Sort >= 2 andalso Sort =< 10 ->
    {ok, #rank_reward_base{
            items = [{29233, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在跨服飞仙情圣榜排名第~w名，获得了【魅力礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(?rank_cross_glamor, Sort) when Sort =:= 1 ->
    {ok, #rank_reward_base{
            items = [{29234, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在跨服鲜花宝贝榜排名第~w名，获得了【魅力礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(?rank_cross_glamor, Sort) when Sort >= 2 andalso Sort =< 10 ->
    {ok, #rank_reward_base{
            items = [{29233, 1, 1}]
            ,subject = ?L(<<"玫瑰佳人，魅力无限">>)
            ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。爱恋新年活动期间，您在跨服鲜花宝贝榜排名第~w名，获得了【魅力礼包】！\n请注意查收，祝您游戏愉快！">>), [Sort])
         }
    };

get(_, _) -> false.
