%%----------------------------------------------------
%% 宠物真身激活奖励
%% @author jackguan@jieyou.cn 
%%----------------------------------------------------
-module(pet_rb_reward).

-export([
        listener/3
    ]).

-include("item.hrl").
-include("common.hrl").

-ifdef(debug).
%% 活动开始时间
-define(step_time_open_beg, {{2013, 4, 2}, {0, 0, 1}}).
-else.
%% 活动开始时间
-define(step_time_open_beg, {{2013, 4, 3}, {00, 00, 01}}).
-endif.

%% 活动结束时间
-define(step_time_open_end, {{2013, 4, 7}, {23, 59, 59}}).

%% 活动期间，激活一个紫色品质以上的仙宠真身卡可获得幸运金币*5的额外奖励
%% deliver(#role{id = {Rid, SrvId}, name = Name}, MailInfo) ->
%% MailInfo =  {Subject, Content, Assets, Items} | {Subject, Content}
listener(pet_rb_qua, Role, CardId) ->
    case item_data:get(CardId) of
        {false, Reason} -> ?ERR("~w", [Reason]), ignore;
        {ok, #item_base{quality = Quality}} ->
            campaign_listener:handle(pet_rb_qua, Role, Quality), %% 后台活动
            do(Role, Quality)
    end.

do(Role, Quality) when Quality >= ?quality_purple ->
    Now = util:unixtime(),
    Beg = util:datetime_to_seconds(?step_time_open_beg),
    End = util:datetime_to_seconds(?step_time_open_end),
    case Now >= Beg andalso Now =< End of
        true ->
            Items = item_reward(Quality),
            Sub = <<"仙宠真身，快乐激活">>,
            Text = <<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持，清明活动期间您成功激活一个紫色品质以上的仙宠真身，获得了额外大礼奖励，请注意查收！谢谢您的支持，祝您游戏愉快！">>,
            MailInfo = {Sub, Text, [], Items},
            mail_mgr:deliver(Role, MailInfo);
        _ ->
            ok
    end;
do(_Role, _Quality) ->
    ok.

%% 奖励
item_reward(Quality) when Quality >= ?quality_purple ->
    [{33118, 1, 5}];
item_reward(_) -> [].
