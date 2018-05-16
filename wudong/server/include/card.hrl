%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 14. 二月 2015 17:36
%%%-------------------------------------------------------------------
-author("fzl").

-define(CARD_ETS,card_ets).  %%卡号ets
-define(USER_CARD_ETS,user_card_ets).  %%玩家对应已使用卡号ets

-record(card,{
    card_id = 0, %%卡号
    gift_id = 0, %%礼包ID
    is_use = 0, %%是否被使用
    user = {0,0,0}  %%使用者key={id,sn,pf}
}).

-record(user_card,{
    user = {0,0,0},  %%使用者key={id,sn,pf}
    card_id = []  %%卡列表
}).


