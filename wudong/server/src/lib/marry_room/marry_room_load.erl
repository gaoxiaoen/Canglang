%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 20:24
%%%-------------------------------------------------------------------
-module(marry_room_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("marry_room.hrl").

%% API
-export([
    update/1,

    load/1,
    load_all/0
]).

update(#st_marry_room{} = StMarryRoom) ->
    #st_marry_room{
        pkey = Pkey,
        rp_val = RpVal,
        qm_val = QmVal,
        is_marry = IsMarry,
        love_desc = LoveDesc,
        love_desc_type = LoveDescType,
        love_desc_time = LoveDescTime,
        my_look = MyLook,
        my_face = MyFace,
        is_first_photo = IsFirstPhoto
    } = StMarryRoom,
    MyLookBin = util:term_to_bitstring(MyLook),
    MyFaceBin = util:term_to_bitstring(MyFace),
    Sql = io_lib:format("replace into  player_marry_room set pkey=~p, rp_val=~p,qm_val=~p,is_marry=~p,love_desc='~s',love_desc_type=~p,love_desc_time=~p,my_look='~s',my_face='~s',is_first_photo=~p ",
        [Pkey, RpVal,QmVal,IsMarry,LoveDesc,LoveDescType,LoveDescTime,MyLookBin,MyFaceBin,IsFirstPhoto]),
    db:execute(Sql),
    ok;

update(#ets_marry_room{} = EtsMarryRoom) ->
    #ets_marry_room{
        pkey = Pkey,
        rp_val = RpVal,
        qm_val = QmVal,
        is_marry = IsMarry,
        love_desc = LoveDesc,
        love_desc_type = LoveDescType,
        love_desc_time = LoveDescTime,
        my_look = MyLook,
        my_face = MyFace,
        is_first_photo = IsFirstPhoto
    } = EtsMarryRoom,
    MyLookBin = util:term_to_bitstring(MyLook),
    MyFaceBin = util:term_to_bitstring(MyFace),
    Sql = io_lib:format("replace into player_marry_room set pkey=~p, rp_val=~p,qm_val=~p,is_marry=~p,love_desc='~s',love_desc_type=~p,love_desc_time=~p,my_look='~s',my_face='~s',is_first_photo=~p ",
        [Pkey, RpVal,QmVal,IsMarry,LoveDesc,LoveDescType,LoveDescTime,MyLookBin,MyFaceBin,IsFirstPhoto]),
    db:execute(Sql),
    ok.

load(Pkey) ->
    Sql = io_lib:format("select rp_val,qm_val,is_marry,love_desc,love_desc_type,love_desc_time,my_look,my_face,is_first_photo from player_marry_room where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [RpVal,QmVal,IsMarry,LoveDesc,LoveDescType,LoveDescTime,MyLookBin,MyFaceBin,IsFirstPhoto] ->
            #st_marry_room{
                pkey = Pkey,
                rp_val = RpVal,
                qm_val = QmVal,
                is_marry = IsMarry,
                love_desc = LoveDesc,
                love_desc_type = LoveDescType,
                love_desc_time = LoveDescTime,
                my_look = util:bitstring_to_term(MyLookBin),
                my_face = util:bitstring_to_term(MyFaceBin),
                is_first_photo = IsFirstPhoto
            };
        _ ->
            #st_marry_room{pkey = Pkey}
    end.

load_all() ->
    Sql = io_lib:format("select a.pkey,b.nickname,b.career,b.sex,b.vip_lv,a.rp_val,a.qm_val,a.is_marry,a.love_desc,a.love_desc_type,a.love_desc_time,a.my_look,a.my_face,a.is_first_photo from player_marry_room a left join player_state b on a.pkey = b.pkey", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            Rows;
        _ ->
            []
    end.
