%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 三月 2016 上午11:00
%%%-------------------------------------------------------------------
-module(online_gift).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("tips.hrl").

%% API
-export([
    init/1,
    get_gift/0,
    get_gift/1,
    check_get_online_gift/1,
    logout/1,
    update/1,

    check_get_online_gift_state/1
]).

init(Player) ->
    OnlineGiftSt = activity_load:dbget_online_gift(Player),
    lib_dict:put(?PROC_STATUS_ONLINE_GIFT, OnlineGiftSt),
    update(Player),
    get_gift(),
    Player.

logout(_Player) ->
    OnlineGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_GIFT),
    activity_load:dbup_online_gift(OnlineGiftSt),
    ok.

update(Player) ->
    OnlineGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_GIFT),
    Now = util:unixtime(),
    #st_online_gift{
        get_time = GetTime
    } = OnlineGiftSt,
    NewOnlineGiftSt =
        case util:is_same_date(Now,GetTime) of
            true -> OnlineGiftSt;
            false ->
                OnlineGiftSt#st_online_gift{
                    get_time = Now,
                    get_list = []
                }
        end,
    lib_dict:put(?PROC_STATUS_ONLINE_GIFT, NewOnlineGiftSt),
    Player.

check_get_online_gift_state(_Player) ->
    OnlineGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_GIFT),
    #st_online_gift{
        get_list = GetList
    } = OnlineGiftSt,
    ActList = get_act_list(GetList),
    case ActList == [] of
        true ->
            #tips{};
        false ->
            #tips{state = 1}
    end.

%%领取在线奖励
get_gift(_) ->
    get_gift().
get_gift() ->
    OnlineGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_GIFT),
    #st_online_gift{
        pkey = Pkey,
        get_list = GetList
    } = OnlineGiftSt,
    ActList = get_act_list(GetList),
    NewOnlineGiftSt = OnlineGiftSt#st_online_gift{
        get_list = GetList ++ [B#base_online_gift.act_id||B<-ActList],
        get_time = util:unixtime()
    },
    lib_dict:put(?PROC_STATUS_ONLINE_GIFT, NewOnlineGiftSt),
    get_gift_helper(ActList,Pkey).
get_gift_helper([],_Pkey) -> ok;
get_gift_helper([Base|Tail],Pkey) ->
    #base_online_gift{
        gift_list = GoodsList,
        mail_title = Title,
        mail_content = Content
    } = Base,
    mail:sys_send_mail([Pkey],Title,Content,GoodsList),
    get_gift_helper(Tail,Pkey).

%%获取可领取的活动列表
get_act_list(GetList) ->
    Now = util:unixtime(),
    ActList = activity:get_work_list(data_online_gift),
    get_act_list_helper(ActList,Now,GetList,[]).
get_act_list_helper([],_Now,_GetList,AccList) -> AccList;
get_act_list_helper([Base|Tail],Now,GetList,AccList) ->
    #base_online_gift{
        act_id = ActId,
        open_time = [{Hour1,Min1},{Hour2,Min2}]
    } = Base,
    Today = util:unixdate(),
    TSec1 = Today+Hour1*3600+Min1*60,
    TSec2 = Today+Hour2*3600+Min2*60,
    case Now >= TSec1 andalso Now =< TSec2 of
        false -> %%不在活动时间
            get_act_list_helper(Tail,Now,GetList,AccList);
        true ->
            case lists:member(ActId,GetList) of
                true -> %%今天已经领取了
                    get_act_list_helper(Tail,Now,GetList,AccList);
                false ->
                    get_act_list_helper(Tail,Now,GetList,AccList++[Base])
            end
    end.

%%检查是否有可领取的在线奖励
check_get_online_gift(Time) ->
    ActTimeList = activity:get_work_list(data_online_gift),
    Today = util:unixdate(),
    Time1 = Time - (Time rem 60),
    F = fun(Base) ->
        #base_online_gift{
            open_time = [{Hour1,Min1},_]
        } = Base,
        StartTime = Today+Hour1*3600+Min1*60,
        case Time1 == StartTime of
            true ->
                handle_online:online_apply(online_gift,get_gift,[]);
            false ->
                skip
        end
    end,
    lists:foreach(F,ActTimeList).
