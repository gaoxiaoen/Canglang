%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 五月 2016 下午7:42
%%%-------------------------------------------------------------------
-module(ad).
-author("fengzhenlin").
-include("activity.hrl").
-include("server.hrl").
-include("daily.hrl").

%% API
-export([
    get_ad_list/1
]).

%% get_ad_list(Player) ->
%%     case activity:get_work_list(data_ad) of
%%         [] -> skip;
%%         [Base|_] ->
%%             #base_ad{
%%                 min_lv = MinLv,
%%                 pic_list = PicList
%%             } = Base,
%%             case Player#player.lv >= MinLv of
%%                 true ->
%%                     LastTime =  daily:get_count(?DAILY_OPEN_AD),
%%                     Now = util:unixtime(),
%%                     CdTime =
%%                         case config:is_debug() of
%%                             true -> 0;
%%                             false -> 1800
%%                         end,
%%                     %case Now - LastTime > 1800 of
%%                     case Now - LastTime > CdTime of
%%                         true ->
%%                             OpenDay = config:get_open_days(),
%%                             PicList1 = [tuple_to_list(Info) || Info <- PicList],
%%                             {ok, Bin} = pt_431:write(43199, {OpenDay, PicList1}),
%%                             server_send:send_to_sid(Player#player.sid, Bin),
%%                             daily:set_count(?DAILY_OPEN_AD, Now);
%%                         false ->
%%                             skip
%%                     end;
%%                 false ->
%%                     skip
%%             end
%%     end.

get_ad_list(Player) ->
    ModList = activity:all_act_mod(),
    case Player#player.lv < 41 of
        true -> skip;
        false ->
            List1 =
                case activity:get_work_list(data_ad) of
                    [] -> [];
                    [Base|_] ->
                        #base_ad{
                            pic_list = BasePicList
                        } = Base,
                        BasePicList
                end,
            LastTime =  daily:get_count(?DAILY_OPEN_AD),
            Now = util:unixtime(),
            CdTime =
                case config:is_debug() of
                    true -> 0;
                    false -> 1800
                end,
            case Now - LastTime > CdTime of
                true ->
                    OpenDay = config:get_open_days(),
                    PicList0 = get_ad_list_1(ModList,[]),
                    PicList = PicList0 ++ List1,
                    case PicList of
                        [] -> skip;
                        _ ->
                            PicList1 = [tuple_to_list(Info) || Info <- PicList],
                            {ok, Bin} = pt_431:write(43199, {OpenDay, PicList1}),
                            server_send:send_to_sid(Player#player.sid, Bin),
                            daily:set_count(?DAILY_OPEN_AD, Now)
                    end;
                false ->
                    skip
            end
    end.

get_ad_list_1([], AccAdList) -> AccAdList;
get_ad_list_1([{_Id,Mod}|Tail], AccAdList) ->
    case activity:get_work_list(Mod) of
        [] -> get_ad_list_1(Tail, AccAdList);
        [Base|_] ->
            case catch erlang:element(3, Base) of
                ActInfo when is_record(ActInfo, act_info) ->
                    get_ad_list_1(Tail, ActInfo#act_info.ad_pic ++ AccAdList);
                _ ->
                    get_ad_list_1(Tail, AccAdList)
            end
    end.
