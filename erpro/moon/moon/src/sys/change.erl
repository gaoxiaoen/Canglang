%%----------------------------------------------------
%% 通用兑换服务
%% @author mobin
%% @end
%% 
%%----------------------------------------------------
-module(change).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
    start_link/1
    ,stop/1
]).
-include("common.hrl").
-include("storage.hrl").
-include("role.hrl").
-include("item.hrl").
-include("change.hrl").

-export([behaviour_info/1]).  
behaviour_info(callbacks) ->  
    [
        {list, 1},             
        {buy, 3},             
        {items, 0},             
        {pay, 2}
    ];
behaviour_info(_Other) ->  
    undefined.  

%-----------------
%% 进程状态数据
-record(state, {
        mod
        ,items = []           %% 兑换物品
        ,quota_info = []          %% 已限购角色 {{Id, Rid}, Num}
    }
).

-define(seconds_of_day, 86400). 

start_link(Mod)->
    gen_server:start_link({local, Mod}, ?MODULE, [Mod], []).

stop(Mod) ->
    gen_server:cast(Mod, stop).

%% -------------内部实现--------------
init([Mod]) ->
    ?INFO("[~w] 正在启动...", [Mod]),
    {ok, Items} = Mod:items(),
    Tomorrow = util:unixtime(today) + ?seconds_of_day + 1,
    Now = util:unixtime(),
    erlang:send_after((Tomorrow - Now) * 1000, self(), tick),
    ?INFO("[~w] 启动完成", [Mod]),
    {ok, #state{mod = Mod, items = Items}}.

handle_call({items, Rid}, _From, State = #state{items = Items, quota_info = QuotaInfo}) ->
    {reply, set_quota(Items, Rid, QuotaInfo), State};

%% 购买限购商品
handle_call({buy, Id, Num, Role = #role{id = Rid}}, _From, State = #state{items = Items,
        mod = Mod, quota_info = QuotaInfo}) ->
    case get_quota_item(Id, Rid, QuotaInfo, Num, Items) of
        {false, Reason} ->
            {reply, {false, Reason}, State};
        {ok, Item} ->
            Result = buy_item(Item, Num, Role, Mod),
            case Result of
                {false, Reason} ->
                    {reply, {false, Reason}, State};
                Reply ->
                    QuotaInfo2 = case lists:keyfind({Id, Rid}, 1, QuotaInfo) of
                        false ->
                            [{{Id, Rid}, Num} | QuotaInfo];
                        {_, BoughtNum} ->
                            lists:keyreplace({Id, Rid}, 1, QuotaInfo, {{Id, Rid}, BoughtNum + Num})
                    end,
                    {reply, Reply, State#state{quota_info = QuotaInfo2}}
            end
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_, State) ->
    {noreply, State}.

%% 定时轮循
handle_info(tick, State = #state{}) ->
    Tomorrow = util:unixtime(today) + ?seconds_of_day + 1,
    Now = util:unixtime(),
    erlang:send_after((Tomorrow - Now) * 1000, self(), tick),
    {noreply, State#state{quota_info = []}}; 

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ?ERR("服务进程关闭 ~w", [_Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ---------- 内部函数 -------------
set_quota(Items, Rid, QuotaInfo) ->
    set_quota(Items, Rid, QuotaInfo, []).
set_quota([], _, _, Return) ->
    lists:reverse(Return);
set_quota([Item | T], Rid, QuotaInfo, Return) ->
    case lists:keyfind({Item#change_item.id, Rid}, 1, QuotaInfo) of
        false ->
            set_quota(T, Rid, QuotaInfo, [Item | Return]);
        {_, Num} ->
            set_quota(T, Rid, QuotaInfo, [Item#change_item{count = Item#change_item.count - Num} | Return])
    end.

get_quota_item(Id, Rid, QuotaInfo, Num, Items) ->
    case lists:keyfind(Id, #change_item.id, Items) of
        false -> 
            {false, ?MSGID(<<"不存在此物品，无法兑换">>)};
        Item ->
            check_quota(Id, Rid, QuotaInfo, Item, Num)
    end.

check_quota(Id, Rid, QuotaInfo, Item = #change_item{count = Count}, Num) ->
    BoughtNum = case lists:keyfind({Id, Rid}, 1, QuotaInfo) of
        false -> 0;
        {_, _BoughtNum} -> _BoughtNum
    end,
    case BoughtNum + Num > Count of
        true -> 
            {false, ?MSGID(<<"超过了今天的兑换上限，无法兑换">>)};
        false ->
            {ok, Item}
    end.

buy_item(#change_item{base_id = BaseId, price = Price, bind = Bind}, Num, Role = #role{assets = Assets}, Mod) ->
    case Mod:pay(Assets, Price * Num) of
        {ok, Assets2} ->
            case create_item(BaseId, Bind, Num, Role) of
                {false, Reason} ->
                    {false, Reason};
                {ok, NewBag, _Items} ->
                    {ok, Assets2, NewBag}
            end;
        Other ->
            Other
    end.

create_item(BaseId, BindType, Num, Role) -> 
    case item:make(BaseId, BindType, Num) of
        false ->
            {false, ?MSGID(<<"物品数据异常，兑换失败">>)};
        {ok, Items} ->
            case storage:add(bag, Role, Items) of
                false -> 
                    {false, ?MSGID(<<"你的背包空间不足，兑换失败">>)};
                {ok, NewBag} ->
                    {ok, NewBag, Items}
            end
    end.
