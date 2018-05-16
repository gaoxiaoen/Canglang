%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 20:23
%%%-------------------------------------------------------------------
-module(marry_room_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("marry_room.hrl").

%% API
-export([
    init/1,
    init_ets/0,
    sys_init/0
]).

init(#player{key = Pkey} = Player) ->
    IsMarry = ?IF_ELSE(Player#player.marry#marry.mkey == 0, 0, 1),
    StMarryRoom =
        case player_util:is_new_role(Player) of
            true ->
                #st_marry_room{pkey = Pkey, is_marry = IsMarry};
            false ->
                St = marry_room_load:load(Pkey), St#st_marry_room{is_marry = IsMarry}
        end,
    NewStMarryRoom = marry_room:update_friend(StMarryRoom),
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewStMarryRoom),
    RR = marry_room:to_record(NewStMarryRoom, Player),
    ets:insert(?ETS_MARRY_ROOM, RR),
    Player.

init_ets() ->
    ets:new(?ETS_MARRY_ROOM, [{keypos, #ets_marry_room.pkey} | ?ETS_OPTIONS]).

sys_init() ->
    F = fun([Pkey, NickName, Career, Sex, VipLv, RpVal,QmVal,IsMarry,LoveDesc,LoveDescType,LoveDescTime,MyLookBin,MyFaceBin,IsFirstPhoto]) ->
        EtsMarryRoom =
            #ets_marry_room{
                pkey = Pkey,
                nickname = NickName,
                career = Career,
                sex = Sex,
                avatar = player_load:dbget_player_avatar(Pkey),
                vip_lv = VipLv,
                rp_val = RpVal,
                qm_val = QmVal,
                is_marry = IsMarry,
                love_desc = LoveDesc,
                love_desc_type = LoveDescType,
                love_desc_time = LoveDescTime,
                my_look = util:bitstring_to_term(MyLookBin),
                my_face = util:bitstring_to_term(MyFaceBin),
                is_first_photo = IsFirstPhoto
            },
        ets:insert(?ETS_MARRY_ROOM, EtsMarryRoom)
    end,
    lists:map(F, marry_room_load:load_all()).