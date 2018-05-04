%%----------------------------------------------------
%% 剧情
%% @author qingxuan
%%----------------------------------------------------

-module(story_data).
-include("common.hrl").
-export([
    can_join_npc/4
    ,story_to_map/1
]).

%% 是否跟随并参战的队友npc
%% (MapBaseId, StoryId, SectionId, NpcBaseId) -> true | false
can_join_npc(120, 1, 5, 10282) -> true;
can_join_npc(10031, 5, 1355, 10243) -> true;
can_join_npc(10072, 71, 7102, 13056) -> true;
can_join_npc(1300, 73, 7305, 13053) -> true;
can_join_npc(10012, 1001201, 1001201, 13056) -> true;
can_join_npc(11011, 99, 5403, 10248) -> true;
can_join_npc(11021, 98, 9801, 10248) -> true;
can_join_npc(_MapId, _StoryId, _SectionId, _NpcId) -> false.

%% 剧情发生成哪个场景
%% (StoryId) -> MapBaseId
story_to_map(1) -> 120;
story_to_map(5) -> 10031;
story_to_map(71) -> 10072;
story_to_map(73) -> 1300;
story_to_map(1001201) -> 10012;
story_to_map(99) -> 11011;
story_to_map(98) -> 11021;
story_to_map(_StoryId) -> undefined.

