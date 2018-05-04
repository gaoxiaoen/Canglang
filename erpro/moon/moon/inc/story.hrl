%%----------------------------------------------------
%% 剧情
%% @author qingxuan
%%----------------------------------------------------

-record(story, {
    id
    ,npcs = []
}).

-record(story_npc, {
    id
    ,base_id
    ,section_id
    ,story_id
}).
