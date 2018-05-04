%%%-------------------------------------------------------------------
%%% File        :common_letter.erl
%%%-------------------------------------------------------------------
-module(common_letter).

-include("common.hrl").
-include("common_server.hrl").
%%---------------------------------------------------------

%%------------------------------------------------------
-define(LETTER_TYPE_P2P, 0).
-define(LETTER_TYPE_CLAN, 1).
-define(LETTER_TYPE_SYSTEM,2).
-define(LETTER_TYPE_ALSO, 3).

%%----------------------------------------------------

%% API
-export([
         send/2,
         sys2p/3,
         sys2p/4,  %%发送系统信件接口
         sys2p/5,
         sys2p/6,
         sys2single/4,
         send_letter_package/1,
         get_text_with_npc/3,
         get_effective_time/0,
         get_effective_time/1,
         get_effective_time/2,
         create_temp/2,
         clean_letter/1
        ]).

send(_RoleID, _Content) ->
    ok.

clean_letter(RoleId)->
    ?TRY_CATCH(erlang:send(mgeew_letter_server,{clean_letter,RoleId}),Err).

%% ==================================================================================
%% ----------------------------- common tool ----------------------------------------
%% ==================================================================================
 
%% 发送系统信件用此接口
sys2p(RoleID, Text, Title) ->
    sys2p(RoleID,Text,Title,[], 14, common_tool:now()). 
sys2p(RoleID,Text,Title,Day)->
    sys2p(RoleID,Text,Title,[],Day,common_tool:now()). 
sys2p(RoleID,Text,Title,GoodsList,Day)->
    sys2p(RoleID,Text,Title,GoodsList,Day,common_tool:now()).
sys2p(RoleID,Text,Title,GoodsList,Day,StartTime) ->
    Info ={send_sys2p, RoleID, Title, Text, GoodsList, Day, StartTime},
    ?TRY_CATCH(erlang:send(mgeew_letter_server,Info),Err).

%% gm发送私人信件
sys2single(RoleID,Title,Text,GoodsList)->
    Info={send_sys2single,RoleID,Title,Text,GoodsList},
    send_letter_package(Info).

%% 个别信件接口
send_letter_package(Info)->
    case erlang:whereis(mgeew_letter_server) of
        undefined->
            ?ERROR_MSG("mgeew letter server does not exist,Info=~w", [Info]),
            {error,common_lang:get_lang(1)};
        Pid->
            erlang:send(Pid,Info),
            ok
    end.

get_text_with_npc(TextContent,FactionID,List)->
    lists:flatten(
      io_lib:format(
        TextContent,lists:map(
          fun(Element)->
                  case Element of
                      {HWnpc,YLnpc,WLnpc} ->  
                          case FactionID of
                              1->HWnpc;
                              2->YLnpc;
                              3->WLnpc
                          end;
                      Tmp->
                          Tmp
                  end
          end,List))).



%% 获取信件有效时间


    

get_effective_time()->
    Day = ?LETTER_DEFAULT_SAVE_DAYS,
    get_effective_time(Day).
get_effective_time(Day)->
    SendTime = common_tool:now(),
    get_effective_time(SendTime,Day).
get_effective_time(SendTime,Day)->
    OutTime =SendTime + Day * 24 * 60 * 60,
    {SendTime,OutTime}.

%% 生成common信件格式
create_temp(Template,List)->
    {Template,List}. 
