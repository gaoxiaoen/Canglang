%% --------------------------------------------------------------------
%% 剧情
%% @author 
%% --------------------------------------------------------------------
-module(story_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").

%% 剧情npc变成可参战npc
handle(10600, {StoryId, SectionNpcList}, Role) ->
    case story_npc:join(Role, StoryId, SectionNpcList) of
        {ok, Role0} ->
            {reply, {}, Role0};
        {error, _Reason} ->
            ?DUMP(_Reason),
            {reply, {}}
    end;

%% 删除剧情npc
handle(10601, {NpcBaseIdList}, Role) ->
    case story_npc:leave(Role, NpcBaseIdList) of
        {ok, Role0} ->
            {ok, Role0};
        {error, _Reason} ->
            ?DUMP(_Reason),
            {ok}
    end;

handle(_Cmd, _Data, _Role) ->
    {ok}.
