%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%     %%玩家AI镜像处理
%%% @end
%%% Created : 13. 十一月 2015 14:38
%%%-------------------------------------------------------------------
-module(player_guide).
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    init/1,
	guide_updata/3,
	get_guide_list/1,
	logout/1
]).

-record(st_guide,{
    pkey = 0,
    guide_list = [],  %%[{key,val}]
    is_db_update = 0
}).

get_dict() ->
    lib_dict:get(?PROC_STATUS_PLAYER_GUIDE).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_PLAYER_GUIDE, St).

init(Player)->
    InitSt = #st_guide{
        pkey = Player#player.key
    },
    NewSt =
        case player_util:is_new_role(Player) of
            true->
                InitSt;
            false->
                SQL = io_lib:format("select guide_list from player_guide where pkey = ~p",[Player#player.key]),
                case db:get_row(SQL) of
                    []->
                        InitSt;
                    [ListBin] ->
                        InitSt#st_guide{
                            guide_list = util:bitstring_to_term(ListBin)
                        }
                end
        end,
    put_dict(NewSt),
	Player.


guide_updata(_Player,Key,Value)->
	St = get_dict(),
	case lists:keytake(Key, 1, St#st_guide.guide_list) of
		false ->
			NewList = [{Key, Value}|St#st_guide.guide_list],
			NewSt = St#st_guide{
                guide_list = NewList,
                is_db_update = 1
            },
            put_dict(NewSt);
		{value,_,List1}->
            NewList = [{Key, Value}|List1],
            NewSt = St#st_guide{
                guide_list = NewList,
                is_db_update = 1
            },
            put_dict(NewSt)
	end.

get_guide_list(Player)->
	St = get_dict(),
    Data = util:list_tuple_to_list(St#st_guide.guide_list),
	{ok,Bin} = pt_130:write(13008,{Data}),
    server_send:send_to_sid(Player#player.sid,Bin),
	ok.

logout(Player)->
	St = get_dict(),
	case St#st_guide.is_db_update == 1 of
        true ->
            SQL = io_lib:format("replace into player_guide set pkey = ~p, guide_list = '~s'",
                [Player#player.key, util:term_to_bitstring(St#st_guide.guide_list)]),
            db:execute(SQL);
        false ->
            skip
    end,
	ok.