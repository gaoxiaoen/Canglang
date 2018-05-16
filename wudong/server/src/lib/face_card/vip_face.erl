%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2018 16:37
%%%-------------------------------------------------------------------
-module(vip_face).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("face_card.hrl").

%% API
-export([
    init/1,
    update_db/1,
    use_card/2,
    discard/0,
    get_vip_face_info/1
]).

init(#player{key = Pkey} = Player) ->
    Sql = io_lib:format("select vip_face_list from player_face where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [VipFaceListBin] ->
            VipFaceList = util:bitstring_to_term(VipFaceListBin),
            NewFaceVipCard = #face_vip_card{pkey = Pkey, list = VipFaceList},
            lib_dict:put(?PROC_STATUS_VIP_FACE, NewFaceVipCard),
            ok;
        _ ->
            lib_dict:put(?PROC_STATUS_VIP_FACE, #face_vip_card{pkey = Pkey})
    end,
    Player.

update_db(#face_vip_card{pkey = Pkey, list = VipFaceList}) ->
    Sql = io_lib:format("replace into player_face set pkey=~p, vip_face_list='~s'",
        [Pkey, util:term_to_bitstring(VipFaceList)]),
    db:execute(Sql),
    ok.

use_card(Player, GoodsType) ->
    St = lib_dict:get(?PROC_STATUS_VIP_FACE),
    #face_vip_card{list = VipFaceList} = St,
    case data_vip_face:get(GoodsType) of
        [] -> skip;
        #base_face_vip_card{vip = Vip, expire_time = ExpireTime} ->
            if
                Player#player.vip_lv >= Vip -> skip;
                true ->
                    NewVipFaceList =
                        case lists:keytake(Vip, 1, VipFaceList) of
                            false ->
                                [{Vip, util:unixtime() + ExpireTime} | VipFaceList];
                            {value, _Val, Rest} ->
                                [{Vip, util:unixtime() + ExpireTime} | Rest]
                        end,
                    NewSt = St#face_vip_card{list = NewVipFaceList},
                    lib_dict:put(?PROC_STATUS_VIP_FACE, NewSt),
                    update_db(NewSt)
            end
    end.

discard() ->
    St = lib_dict:get(?PROC_STATUS_VIP_FACE),
    #face_vip_card{list = FaceList, pkey = Pkey} = St,
    Now = util:unixtime(),
    F = fun({Vip, Time} = R) ->
        if
            Time < Now ->
                {Title, Content0} = t_mail:mail_content(169),
                Content = io_lib:format(Content0, [Vip]),
                mail:sys_send_mail([Pkey], Title, Content, []),
                [];
            true -> [R]
        end
    end,
    NewList = lists:flatmap(F, FaceList),
    NewSt = St#face_vip_card{list = NewList},
    lib_dict:put(?PROC_STATUS_VIP_FACE, NewSt),
    if
        NewList /= FaceList ->
            update_db(NewSt);
        true ->
            ok
    end.

get_vip_face_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_VIP_FACE),
    #face_vip_card{list = FaceList} = St,
    Now = util:unixtime(),
    F = fun({Vip, Time}) -> [Vip, max(0, Time-Now)] end,
    lists:map(F, FaceList).