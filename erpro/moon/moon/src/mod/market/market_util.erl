%%----------------------------------------------------
%% @doc 市场模块工具包 
%%
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(market_util).

-export([
        calc_tax/2
    ]
).

-include("market.hrl").

%% 计算税额(保管费)
calc_tax(sale, {CoinType, Coin, Time}) ->
    case CoinType of
        ?assets_type_coin -> %% 铜线
            case Time of
                6  -> round(Coin * 0.02);
                12 -> round(Coin * 0.035);
                24 -> round(Coin * 0.06)
            end;
        ?assets_type_gold -> %% 晶钻
            case Time of
                6  -> Coin * 20;
                12 -> Coin * 30;
                24 -> Coin * 40
            end
    end;

calc_tax(sale, Price) ->
    Price * 10;

%% 计算求购信息税金
calc_tax(buy, {Time, Notice}) ->
    Tax = case Time of
        6 ->
            1000;
        12 ->
            2000;
        24 ->
            3000
    end,
    case Notice of
        1 -> Tax + 2000;
        _ -> Tax
    end.
