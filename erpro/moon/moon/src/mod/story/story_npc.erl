%% --------------------------------------------------------------------
%% 剧情npc
%% @author 
%% --------------------------------------------------------------------
-module(story_npc).
-export([
    login/1
    ,can_join/4
    ,join/3
    ,leave/2
    ,clear/2
    ,clear/1
]).
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("story.hrl").

login(Role = #role{story = undefined}) ->
    Role#role{story = #story{npcs = []}}; 
login(Role = #role{story = #story{npcs = Npcs}}) ->
    lists:foldr(fun(#story_npc{id = NpcId, base_id = NpcBaseId}, Role0) ->
        add_to_special(Role0, NpcId, NpcBaseId)
    end, Role, Npcs).
%% 
can_join(MapId, StoryId, SectionId, NpcBaseId) ->
    %% TODO 重复调用合法性检查
    case story_data:can_join_npc(MapId, StoryId, SectionId, NpcBaseId) of
        false -> false;
        true -> true
    end.

%% (#role{}, StoryId, [[SectionId, NpcBaseId, NpcId]]) -> {error, Reason} | {ok, #role{}}
join(Role = #role{pos = #pos{map_base_id = MapBaseId0, map = MapId}}, StoryId, SectionNpcList) ->
    MapBaseId = case MapBaseId0 of
        undefined -> MapId;
        _ -> MapBaseId0
    end,
    NewStory = #story{id = StoryId},
    R = (catch lists:foldr(fun([SectionId, NpcBaseId, NpcId], Role0)->
        case can_join(MapBaseId, StoryId, SectionId, NpcBaseId) of
            true ->
                Role1 = add_to_special(Role0, NpcId, NpcBaseId),
                Role2 = add_to_story(Role1, StoryId, SectionId, NpcId, NpcBaseId),
                Role2;
            false ->
                Role0
        end
    end, Role#role{story = NewStory}, SectionNpcList)),
    case R of
        #role{} -> {ok, R};
        _ -> R
    end.

%% -> #role{}
leave(Role, NpcBaseIdList) ->
    NewRole = lists:fold(fun(NpcBaseId, Role0) ->
        Role1 = remove_from_story(Role0, NpcBaseId),
        remove_from_special(Role1, NpcBaseId)
    end, Role, NpcBaseIdList),
    {ok, NewRole}.

%% -> #role{}
clear(Role = #role{}) ->
    remove_all(Role).
 
%% -> #role{}
clear(Role = #role{pos = #pos{map = OldMapId, map_base_id = OldMapBaseId}, story = Story}, NewMapBaseId) ->
    ToDel = case map:is_town(NewMapBaseId) of
        true -> true;
        _ ->
            case NewMapBaseId of
                OldMapId -> false;
                OldMapBaseId -> false;
                _ -> true
            end                    
    end,
    case ToDel of
        false ->
            #story{id = _StoryId, npcs = _Npcs} = Story,
            ?DEBUG("从地图~p:~p进入地图~p, 不删除剧情~p参战npc~p ????", [OldMapId, OldMapBaseId, NewMapBaseId, _StoryId, _Npcs]),
            Role;
        true ->
            #story{id = StoryId, npcs = _Npcs} = Story,
            ?DEBUG("从地图~p:~p进入地图~p, 删除剧情~p参战npc~p !!!!", [OldMapId, OldMapBaseId, NewMapBaseId, StoryId, _Npcs]),
            case story_data:story_to_map(StoryId) of
                OldMapId -> remove_all(Role);
                OldMapBaseId -> remove_all(Role);
                NewMapBaseId -> Role;
                _ -> remove_all(Role)
            end
    end.
        
%% -> #role{}
add_to_story(Role = #role{story = Story = #story{npcs = Npcs}}, StoryId, SectionId, NpcId, NpcBaseId) ->
    Npc = #story_npc{
        id = NpcId
        ,base_id = NpcBaseId
        ,story_id = StoryId
        ,section_id = SectionId
    },
    Role#role{story = Story#story{npcs = [Npc|Npcs]}}.

%% -> #role{}
add_to_special(Role = #role{special = Special}, NpcId, NpcBaseId) ->
    Special1 = [ {Type, Val1, Val2} || {Type, Val1, Val2} <- Special, not (Type =:= ?special_story_npc andalso Val1 =:= NpcBaseId)],
    Special2 = [ {?special_story_npc, NpcBaseId, list_to_binary(integer_to_list(NpcId))} | Special1],
    Role#role{special = Special2}.

%% -> #role{}
remove_from_special(Role = #role{special = Special}, NpcBaseId) ->
    Special1 = [ {Type, Val1, Val2} || {Type, Val1, Val2} <- Special, not (Type =:= ?special_story_npc andalso Val1 =:= NpcBaseId)],
    Role#role{special = Special1}.

%% -> #role{}
remove_from_story(Role = #role{story = Story = #story{npcs = Npcs}}, NpcBaseId) ->
    NewNpcs = [ Npc || Npc = #story_npc{base_id = Val} <- Npcs, Val =/= NpcBaseId ],
    case NewNpcs of
        [] -> Role#role{story = #story{}};
        _ -> Role#role{story = Story#story{npcs = NewNpcs}}
    end.

%% -> #role{}
remove_all(Role = #role{special = Special}) ->
    Special1 = [ {Type, Val1, Val2} || {Type, Val1, Val2} <- Special, Type =/= ?special_story_npc],
    Role#role{special = Special1, story = #story{}}.
 
