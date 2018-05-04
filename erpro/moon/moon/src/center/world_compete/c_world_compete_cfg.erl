%%----------------------------------------------------
%% 跨服仙道会配置
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_world_compete_cfg).

-export([
        get_white_platforms/0,
        get_platform_group_mapping/2,
        get_all_platform_groups/1,
        assemble_name/2,
        world_compete_type_to_event/1,
        event_to_world_compete_type/1
    ]
).

-include("common.hrl").
-include("world_compete.hrl").
-include("role.hrl").

%% 获取白名单平台（在白名单中的平台才开放仙道会）
%% 返回:all   =   全部都允许
%% 返回:[]    =   全部不允许
%% 返回:[_|_] =   允许部分
get_white_platforms() -> all.
%%get_white_platforms() -> [<<"4399">>].


%% 获取平台分组映射（平台名 -> 平台管理器名） -> atom()
%% WorldCompeteType = integer()
%% Platform = atom() | list()
get_platform_group_mapping(WorldCompeteType, Platform) ->
    Platform1 = util:to_binary(Platform),
    Suffix = case Platform1 of
        %%<<"4399">> -> 1;
        %%<<"91wan">> -> 1;
        %%<<"kugou">> -> 1;
        %%<<"duowan">> -> 1;
        _ -> other
    end,
    assemble_name(WorldCompeteType, Suffix).

%% 获取所有分组后的平台管理器名
get_all_platform_groups(WorldCompeteType) -> [
        %%assemble_name(WorldCompeteType, 1), 
        assemble_name(WorldCompeteType, other)].

%% 组装名称 -> 模块名_仙道会类型_后缀
assemble_name(WorldCompeteType, Suffix) ->
    list_to_atom(atom_to_list(c_world_compete) ++ "_" ++ util:to_list(WorldCompeteType) ++ "_" ++ util:to_list(Suffix)).

%% 仙道会类型 到 event的映射
world_compete_type_to_event(?WORLD_COMPETE_TYPE_11) -> ?event_c_world_compete_11;
world_compete_type_to_event(?WORLD_COMPETE_TYPE_22) -> ?event_c_world_compete_22;
world_compete_type_to_event(?WORLD_COMPETE_TYPE_33) -> ?event_c_world_compete_33.

%% event 到仙道会类型的映射
event_to_world_compete_type(?event_c_world_compete_11) -> ?WORLD_COMPETE_TYPE_11;
event_to_world_compete_type(?event_c_world_compete_22) -> ?WORLD_COMPETE_TYPE_22;
event_to_world_compete_type(?event_c_world_compete_33) -> ?WORLD_COMPETE_TYPE_33.
