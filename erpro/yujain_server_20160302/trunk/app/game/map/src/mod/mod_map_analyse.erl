%% Author: caochuncheng2002@gmail.com
%% Created: 2015-09-17
%% Description: 地图文件分析模块
%% 每一个地图生成一份配置文件
%% 文件名:cfg_mcm_xxx.erl 其中xxx表示地图id
%% 根据U3D生成的地图文件生成服务端相应的配置,U3D地图编辑器生成的地图信息文件格式为xml
%% U3D地图的坐标使用【米】为单位，默认放大100倍，即使用【厘米】为单位
%% 确保每一张地图的坐标不出现负数【策划编辑时需要确认好】
%% 每一个格子的大小为 tile size=50
%% 九宫格子大小为 slice={width=1000,height=1000}
%% 客户端发送给服务端的坐标是{tx,ty,dir} 其中dir表示方向
%% 客户端发送给服务端的地址都是按【厘米】为单的正坐标
%% 客户端发送的坐标不是格子坐标，所以必须转换成格子坐标
%% -define(MAP_TILE_SIZE, 50).
%% -define(MAP_SLICE_WIDTH, 1000).
%% -define(MAP_SLICE_HEIGHT, 1000).
%% tileTx = (tx - (tx rem ?MAP_TILE_SIZE))/?MAP_TILE_SIZE
%% tileTy = (ty - (ty rem ?MAP_TILE_SIZE))/?MAP_TILE_SIZE

-module(mod_map_analyse).

-include("mgeem.hrl").
-include_lib("xmerl/include/xmerl.hrl").

-export([
         do_analyse/0,
         do_analyse/2
        ]).
%% 通过erl -noinput -s mod_map_analyse do_analyse -map_dir "" -cfg_dir "" 来执行命令
do_analyse() ->
    {ok, [[MapDir]]} = init:get_argument(map_dir),
    {ok, [[CfgDir]]} = init:get_argument(cfg_dir),
    do_analyse(MapDir,CfgDir).
%% MapDir:地图配置目录,如: /data/my1/config/base_data/map/
%% CfgDir:地图配置输出目录,如:/data/my1/config/src/map/
%% 注：目录路径必须以 "/"结尾
do_analyse(MapDir,CfgDir) ->
    case catch do_analyse2(MapDir) of
        {error,Reason} ->
            io:format("do map analyse error,MapDir=~s,CfgDir=~s,Reason=~w~n",[MapDir,CfgDir,Reason]);
        {ok,MapFileList} ->
            do_analyse3(MapFileList,MapDir,CfgDir)
    end.
do_analyse2(MapDir) ->
    case filelib:is_dir(MapDir) of
        true ->
            next;
        _ ->
            erlang:throw({error,map_dir_error})
    end,
    case  file:list_dir(MapDir) of
        {ok,FileList} ->
            next;
        Err ->
            FileList = [],
            erlang:throw(Err)
    end,
    MapFileList=get_map_file_list(FileList,MapDir,[]),
    {ok,lists:sort(MapFileList)}.

get_map_file_list([],_MapDir,MapFileList) ->
    MapFileList;
get_map_file_list([File|FileList],MapDir,MapFileList) ->
    case filename:extension(File) of
        ".xml" ->
            case string:len(filename:basename(File)) of
                9 ->
                    get_map_file_list(FileList,MapDir,[MapDir ++ File|MapFileList]);
                _ ->
                    get_map_file_list(FileList,MapDir,MapFileList)
            end;
        _ ->
            SubDir = MapDir ++ File ++ "/",
            case filelib:is_dir(SubDir) of
                true -> 
                    case  file:list_dir(SubDir) of
                        {ok,NewFileList} ->
                            NewMapFileList = get_map_file_list(NewFileList,SubDir,MapFileList),
                            get_map_file_list(FileList,MapDir,NewMapFileList);
                        _ ->
                            get_map_file_list(FileList,MapDir,MapFileList)
                    end;
                _ ->
                    get_map_file_list(FileList,MapDir,MapFileList)
            end
    end.

do_analyse3(MapFileList,MapDir,CfgDir) ->
    {MapInfoList,MapNpcResList,MapBornResList} = do_analyse_map(MapFileList,MapDir,CfgDir,[],[],[]),
    %%生成cfg_map.erl
    gen_cfg_map_erl(CfgDir,MapInfoList,MapBornResList),
    
    %% 生成地图字典配置 cfg_map_dict.erl
    gen_cfg_map_dict_erl(CfgDir,MapInfoList),
    
    %% 生成地图NPC配置 cfg_npc.erl
    gen_cfg_npc_erl(CfgDir,MapNpcResList),
    ok.

do_analyse_map([],_MapDir,_CfgDir,MapInfoList,MapNpcResList,MapBornResList) ->
    {MapInfoList,MapNpcResList,MapBornResList};
do_analyse_map([MapFile|MapFileList],MapDir,CfgDir,MapInfoList,MapNpcResList,MapBornResList) ->
    {Root,_}=xmerl_scan:file(MapFile),
    
    %% 地图基本信息
    [#xmlElement{attributes=MapAttrs}] = xmerl_xpath:string("//scene",Root),
    MapId = attribute_value({integer,scene_id, MapAttrs}),
    MapName = attribute_value({binary,scene_name, MapAttrs}),
    MapType = attribute_value({integer,scene_type, MapAttrs}),
    SubType = attribute_value({integer,sub_type, MapAttrs}),
    MinLevel = attribute_value({integer,min_level, MapAttrs}),
    Width = attribute_value({integer,width, MapAttrs}),
    Height = attribute_value({integer,height, MapAttrs}),
    CfgMapModule=erlang:list_to_atom(lists:concat(["cfg_mcm_",MapId])),
    
    MapInfo=#r_map_info{map_id=MapId,map_name=MapName,
                        map_type=MapType,sub_type=SubType,
                        tile_row=0,tile_col=0,
                        offset_x=0,offset_y=0,
                        width=Width,height=Height,
                        level=MinLevel,
                        mcm_module=CfgMapModule},

    %% 解析格子数据
    TileList = do_analyse_tile(xmerl_xpath:string("//point_list//point",Root),[]),
    %% 解析NPC,出生点，跳转点，怪物等资源点
    ResList = do_analyse_element(MapId,Root),
    
    %% 生成地图配置文件 cfg_mcm_xxxxx.erl
    gen_mcm_xxxxx_erl(CfgDir,MapInfo,TileList,ResList),
    
    
    CurNpcResList = [NResInfo|| #r_map_res{res_type=NResType}=NResInfo<- ResList,
                                NResType =:= ?MAP_ELEMENT_NPC_POINT],
    NewMapNpcResList = CurNpcResList ++ MapNpcResList,
    %% 出生点
    case lists:keyfind(?MAP_ELEMENT_BORN_POINT, #r_map_res.res_type, ResList) of
        false ->
            NewMapBornResList = MapBornResList;
        MapBornRes ->
            NewMapBornResList = [MapBornRes|MapBornResList]
    end,
    
    do_analyse_map(MapFileList,MapDir,CfgDir,[MapInfo | MapInfoList],NewMapNpcResList,NewMapBornResList).

%% 解析格子数据
do_analyse_tile([],TileList) ->
    TileList;
do_analyse_tile([#xmlElement{attributes=TileAttrs} | TileXmlList],TileList) ->
    Tx = attribute_value({integer,tx,TileAttrs}),
    Ty = attribute_value({integer,ty,TileAttrs}),
    PartFlag = attribute_value({integer,part_flag,TileAttrs}),
    case PartFlag of
        1 ->
            Type = ?MAP_REF_TYPE_NOT_WALK;
        _ ->
            Type = ?MAP_REF_TYPE_WALK
    end,
    MapRef = #r_map_ref{tx=Tx,ty=Ty,type=Type},
    do_analyse_tile(TileXmlList,[MapRef | TileList]).

%% 解析NPC,出生点，跳转点，怪物等资源点
do_analyse_element(MapId,Root) ->
    NpcList = do_analyse_element_npc(xmerl_xpath:string("//npc_list//npc",Root),MapId,[]),
    MonsterList = do_analyse_element_monster(xmerl_xpath:string("//monster_list//monster",Root),MapId,[]),
    BornList = do_analyse_element_born(xmerl_xpath:string("//born_list//born",Root),MapId,[]),
    JumpList = do_analyse_element_jump(xmerl_xpath:string("//door_list//door",Root),MapId,[]),
    NpcList ++ MonsterList ++ BornList ++ JumpList.

%% NPC
do_analyse_element_npc([],_MapId,NpcList) ->
    NpcList;
do_analyse_element_npc([#xmlElement{attributes=NpcAttrs} | NpcXmlList],MapId,NpcList) ->
    NpcId = attribute_value({integer,npc_id,NpcAttrs}),
    Tx = attribute_value({integer,tx,NpcAttrs}),
    Ty = attribute_value({integer,tz,NpcAttrs}),
    Dir = attribute_value({integer,rot,NpcAttrs}),
    MapRes = #r_map_res{map_id = MapId,
                        res_type = ?MAP_ELEMENT_NPC_POINT,
                        res_id = NpcId,tx=Tx,ty=Ty,dir=Dir,extra=undefined},
    do_analyse_element_npc(NpcXmlList,MapId,[MapRes | NpcList]).
%% Monster 怪物
do_analyse_element_monster([],_MapId,MonsterList) ->
    MonsterList;
do_analyse_element_monster([#xmlElement{attributes=MonsterAttrs} | MonsterXmlList],MapId,MonsterList) ->
    MonsterId = attribute_value({integer,monster_id,MonsterAttrs}),
    Tx = attribute_value({integer,tx,MonsterAttrs}),
    Ty = attribute_value({integer,tz,MonsterAttrs}),
    Dir = attribute_value({integer,rot,MonsterAttrs}),
    MapRes = #r_map_res{map_id = MapId,
                        res_type = ?MAP_ELEMENT_MONSTER_POINT,
                        res_id = MonsterId,tx=Tx,ty=Ty,dir=Dir,extra=undefined},
    do_analyse_element_monster(MonsterXmlList,MapId,[MapRes | MonsterList]).
%% Born Point 出生点
do_analyse_element_born([],_MapId,BornList) ->
    BornList;
do_analyse_element_born([#xmlElement{attributes=BornAttrs} | BornXmlList],MapId,BornList) ->
    BornId = attribute_value({integer,born_id,BornAttrs}),
    Tx = attribute_value({integer,tx,BornAttrs}),
    Ty = attribute_value({integer,tz,BornAttrs}),
    MapRes = #r_map_res{map_id = MapId,
                        res_type = ?MAP_ELEMENT_BORN_POINT,
                        res_id = BornId,tx=Tx,ty=Ty,dir=0,extra=undefined},
    do_analyse_element_born(BornXmlList,MapId,[MapRes | BornList]).

%% Jump Point 跳转点
do_analyse_element_jump([],_MapId,JumpList) ->
    JumpList;
do_analyse_element_jump([#xmlElement{attributes=JumpAttrs} | JumpXmlList],MapId,JumpList) ->
    JumpId = attribute_value({integer,door_id,JumpAttrs}),
    Tx = attribute_value({integer,tx,JumpAttrs}),
    Ty = attribute_value({integer,tz,JumpAttrs}),
    
    DestMapId = attribute_value({integer,target_scene,JumpAttrs}),
    DestTx = attribute_value({integer,target_tx,JumpAttrs}),
    DestTy = attribute_value({integer,target_tz,JumpAttrs}),
    
    MapRes = #r_map_res{map_id = MapId,
                        res_type = ?MAP_ELEMENT_JUMP_POINT,
                        res_id = JumpId,tx=Tx,ty=Ty,dir=0,
                        extra={DestMapId,DestTx,DestTy}},
    
    do_analyse_element_jump(JumpXmlList,MapId,[MapRes | JumpList]).

%% 获取值
attribute_value({integer,Name,Attributes}) ->
    case lists:keyfind(Name, #xmlAttribute.name, Attributes) of
        #xmlAttribute{value=Value} ->
            erlang:list_to_integer(Value);
        _ ->
            0
    end;
attribute_value({binary,Name,Attributes}) ->
    case lists:keyfind(Name, #xmlAttribute.name, Attributes) of
        #xmlAttribute{value=Value} ->
            unicode:characters_to_binary(Value);
        _ ->
            <<"">>
    end;
attribute_value({Name,Attributes}) ->
    case lists:keyfind(Name, #xmlAttribute.name, Attributes) of
        #xmlAttribute{value=Value} ->
            Value;
        _ ->
            ""
    end.


%%生成cfg_map.erl
gen_cfg_map_erl(CfgDir,MapInfoList,MapBornResList) ->
    CfgMapErl=lists:concat([CfgDir,"cfg_map.erl"]),
    CfgMapHead=lists:concat(["%% -*- coding: latin-1 -*-\n",
                             "%% Author: caochuncheng2002@gmail.com\n",
                             "%% Created: 2013-11-25\n",
                             "%% Description: 地图配置接口模块\n",
                             "%% This file is generated by script tool,Do not edit it.\n\n",
                             "-module(cfg_map).\n\n\n",
                             "-include(\"common_records.hrl\").\n\n"
                             "-export([\n",
                             "         get_map_info/1,\n",
                             "         get_map_bron_point/1,\n",
                             "         get_map_ref/1,\n",
                             "         get_map_monster/1,\n",
                             "         get_map_jump/1,\n",
                             "         get_slice_name/1,\n\n",
                             
                             "         get_all_map_id/0\n",
                             "        ]).\n\n"]),
    file:delete(CfgMapErl),
    file:write_file(CfgMapErl, unicode:characters_to_binary(CfgMapHead), [append]),
    %file:write_file(CfgMapErl, erlang:list_to_binary(CfgMapHead), [append]),
    
    CfgMapFunction=lists:concat(["%% 获取地图可走点\n",
                                 "get_map_ref(MapId) ->\n",
                                 "  case get_map_info(MapId) of\n",
                                 "      [#r_map_info{mcm_module=McmModule}] ->\n",
                                 "          McmModule:get_map_bron_point(MapId);\n",
                                 "      _ ->\n",
                                 "          []\n",
                                 "  end.\n\n",
                                 "%% 获取怪物配置\n",
                                 "get_map_monster(MapId) ->\n",
                                 "  case get_map_info(MapId) of\n",
                                 "      [#r_map_info{mcm_module=McmModule}] ->\n",
                                 "          McmModule:get_map_monster(MapId);\n",
                                 "      _ ->\n",
                                 "          []\n",
                                 "  end.\n\n",
                                 "%% 获取跳转点\n",
                                 "get_map_jump({MapId,Tx,Ty}) ->\n",
                                 "  case get_map_info(MapId) of\n",
                                 "      [#r_map_info{mcm_module=McmModule}] ->\n",
                                 "          McmModule:get_map_jump({MapId,Tx,Ty});\n",
                                 "      _ ->\n",
                                 "          []\n",
                                 "  end.\n\n",
                                 "%% 获取 Slice Info\n",
                                 "get_slice_name({MapId,Tx,Ty}) ->\n",
                                 "  case get_map_info(MapId) of\n",
                                 "      [#r_map_info{mcm_module=McmModule}] ->\n",
                                 "          McmModule:get_slice_name({Tx,Ty});\n",
                                 "      _ ->\n",
                                 "          []\n",
                                 "  end.\n\n"]),
    
    file:write_file(CfgMapErl, unicode:characters_to_binary(CfgMapFunction), [append]),
    %% 地图出生点
    [begin 
         CfgMapBornErl = lists:concat(["get_map_bron_point(",MapId,") ->\n",
                                       "    [{",BornTx,",",BornTy,"}];\n"]),
         file:write_file(CfgMapErl, erlang:list_to_binary(CfgMapBornErl), [append]),
         ok
     end|| #r_map_res{tx=BornTx,ty=BornTy,map_id=MapId} <- MapBornResList],
    CfgMapBornErlEnd = lists:concat(["%% 获取地图出生点信息\n",
                                     "get_map_bron_point(_MapId) ->\n",
                                     "  [].\n\n"]),
    file:write_file(CfgMapErl, unicode:characters_to_binary(CfgMapBornErlEnd), [append]),
    %% 地图信息
    [begin 
         CfgMapInfoErl = lists:concat(["get_map_info(",MapId,") ->\n",
                                       "    [{r_map_info,",MapId,",<<","\"",erlang:binary_to_list(MapName),"\"",">>,",MapType,",",SubType,",",TileRow,",",TileCol,",",OffsetX,",",OffsetY,",",Width,",",Height,",",FactionId,",",MinLevel,",",McmModule,"}];\n"]),
         file:write_file(CfgMapErl, erlang:list_to_binary(CfgMapInfoErl), [append]),
         ok
     end|| #r_map_info{map_id=MapId,map_name=MapName,
                       map_type=MapType,sub_type=SubType,
                       tile_row=TileRow,tile_col=TileCol,
                       offset_x=OffsetX,offset_y=OffsetY,
                       width=Width,height=Height,
                       faction_id=FactionId,level=MinLevel,
                       mcm_module=McmModule} <- MapInfoList],
    CfgMapInfoErlEnd = lists:concat(["%% 获取地图配置信息\n",
                                     "get_map_info(_MapId) ->\n",
                                     "  [].\n\n"]),
    file:write_file(CfgMapErl, unicode:characters_to_binary(CfgMapInfoErlEnd), [append]),
    %% 获取所有地图Id方法生成
    AllMapIdList = [ lists:concat([PMapId]) || #r_map_info{map_id=PMapId} <- MapInfoList],
    AllMapIdListErl = lists:concat(["%% 获取所有地图Id\n",
                                     "get_all_map_id() ->\n",
                                     "    [",string:join(AllMapIdList, ",\n     "),"].\n\n"]),
    file:write_file(CfgMapErl, unicode:characters_to_binary(AllMapIdListErl), [append]),
    io:format("map config file gen succ,path=~s~n", [CfgMapErl]),
    ok.
%% 生成地图字典配置 cfg_map_dict.erl
gen_cfg_map_dict_erl(CfgDir,MapInfoList) ->
    CfgMapDictErl=lists:concat([CfgDir,"cfg_map_dict.erl"]),
    CfgMapDictHead=lists:concat(["%% -*- coding: latin-1 -*-\n"
                                 "%% Author: caochuncheng2002@gmail.com\n",
                                 "%% Created: 2013-11-25\n",
                                 "%% Description: 地图字典信息\n",
                                 "%% This file is generated by script tool,Do not edit it.\n\n",
                                 "-module(cfg_map_dict).\n\n\n",
                                 "-export([\n",
                                 "         get_map_dict/0\n",
                                 "        ]).\n\n"]),
    file:delete(CfgMapDictErl),
    file:write_file(CfgMapDictErl, unicode:characters_to_binary(CfgMapDictHead), [append]),
    CfgErlList = [lists:concat(["{\\\"map_id\\\":",MapId,",",
                                "\\\"name\\\":\\\"",erlang:binary_to_list(MapName),"\\\",",
                                "\\\"type\\\":",MapType,",",
                                "\\\"sub_type\\\":",SubType,",",
                                "\\\"faction_id\\\":",FactionId,"}"])
                    || #r_map_info{map_id=MapId,map_name=MapName,map_type=MapType,sub_type=SubType,
                                   faction_id=FactionId} <- MapInfoList],
    case MapInfoList of
        [] ->
            FunctionErl = lists:concat(["get_map_dict() ->\n",
                                       "    "".\n\n"]);
        _ ->
            FunctionErl = lists:concat(["get_map_dict() ->\n",
                                       "    \"[",string:join(CfgErlList, ",\n      "),"]\".\n\n"])
    end,
    file:write_file(CfgMapDictErl, erlang:list_to_binary(FunctionErl), [append]),
    io:format("map config file gen succ,path=~s~n", [CfgMapDictErl]),
    ok.

%% 生成地图NPC配置 cfg_npc.erl
gen_cfg_npc_erl(CfgDir,MapNpcResList) ->
    CfgNpcErl=lists:concat([CfgDir,"cfg_npc.erl"]),
    CfgNpcHead=lists:concat(["%% -*- coding: latin-1 -*-\n"
                             "%% Author: caochuncheng2002@gmail.com\n",
                             "%% Created: 2015-09-18\n",
                             "%% Description: NPC配置\n",
                             "%% This file is generated by script tool,Do not edit it.\n\n",
                             "-module(cfg_npc).\n\n\n",
                             "-export([\n",
                             "         find/1\n",
                             "        ]).\n\n"]),
    file:delete(CfgNpcErl),
    file:write_file(CfgNpcErl, unicode:characters_to_binary(CfgNpcHead), [append]),

    [begin 
         FunctionErl=lists:concat(["find(",ResId,") ->\n",
                                   "    [{r_map_res,",MapId,",",ResType,",",ResId,",",ResTx,",",ResTy,",0,",ResExtra,"}];\n"]),
         file:write_file(CfgNpcErl, erlang:list_to_binary(FunctionErl), [append]),
         ok
     end|| #r_map_res{map_id=MapId,res_type=ResType,res_id=ResId,tx=ResTx,ty=ResTy,extra=ResExtra} <- MapNpcResList],
    
    FunctionErlEnd=lists:concat(["find(_) ->\n",
                                 "    [].\n\n"]),
    file:write_file(CfgNpcErl, erlang:list_to_binary(FunctionErlEnd), [append]),
    io:format("map config file gen succ,path=~s~n", [CfgNpcErl]),
    ok.

%% 生成地图配置文件 cfg_map_xxxxx.erl,基中xxx表示地图id
%% CfgDir 生成地图配置文件目录
%% MapInfo 地图基本信息#r_map_info{}
%% TileList 地图点信息列表[#r_map_ref{},...]
%% ResPosList 地图资源列表[#r_map_res{},...]
gen_mcm_xxxxx_erl(CfgDir,MapInfo,TileList,ResPosList) ->
    #r_map_info{map_id=MapId,map_name=MapName,
                map_type=MapType,sub_type=SubType,
                tile_row=TileRow,tile_col=TileCol,
                offset_x=OffsetX,offset_y=OffsetY,
                width=Width,height=Height,
                faction_id=FactionId,level=MinLevel,
                mcm_module=McmModule} = MapInfo,
    CfgMapModule=lists:concat(["cfg_mcm_",MapId]),
    CfgMapErl=lists:concat([CfgDir,"cfg_mcm_",MapId,".erl"]),
    CfgMapHead=lists:concat(["%% -*- coding: latin-1 -*-\n"
                             "%% Author: caochuncheng2002@gmail.com\n",
                             "%% Created: 2015-09-18\n",
                             "%% Description: map mcm cofnig\n",
                             "%% This file is generated by script tool,Do not edit it.\n\n",
                             "-module(",CfgMapModule,").\n\n\n",
                             "-export([\n",
                             "         get_map_info/1,\n",
                             "         get_map_bron_point/1,\n",
                             "         get_map_ref/1,\n",
                             "         get_map_monster/1,\n",
                             "         get_map_jump/1,\n",
                             "         get_slice_name/1\n",
                             "        ]).\n\n"]),
    file:delete(CfgMapErl),
    file:write_file(CfgMapErl, unicode:characters_to_binary(CfgMapHead), [append]),
    %% 地图信息
    CfgMapInfoErl = lists:concat(["get_map_info(",MapId,") ->\n",
                                  "    [{r_map_info,",MapId,",",MapType,",",SubType,",<<\"",erlang:binary_to_list(MapName),"\">>,",TileRow,",",TileCol,",",OffsetX,",",OffsetY,",",Width,",",Height,",",FactionId,",",MinLevel,",",McmModule,"}];\n",
                                  "get_map_info(_MapId) ->\n",
                                  "    [].\n\n"]),
    file:write_file(CfgMapErl, erlang:list_to_binary(CfgMapInfoErl), [append]),
    %% 出生点
    case lists:keyfind(?MAP_ELEMENT_BORN_POINT, #r_map_res.res_type, ResPosList) of
        false ->
            CfgBornPointErl=lists:concat(["get_map_bron_point(_MapId) ->\n",
                                          "    [].\n\n"]);
        #r_map_res{tx=BornTx,ty=BornTy} ->
            CfgBornPointErl=lists:concat(["get_map_bron_point(",MapId,") ->\n",
                                          "    [{",BornTx,",",BornTy,"}];\n",
                                          "get_map_bron_point(_MapId) ->\n",
                                          "    [].\n\n"])
    end,
    file:write_file(CfgMapErl, erlang:list_to_binary(CfgBornPointErl), [append]),
    %% 地图格子
    CfgTileErlList = [lists:concat(["{r_map_ref,",TileTx,",",TileTy,",",TileType,"}"]) 
                        || #r_map_ref{type=TileType,tx=TileTx,ty=TileTy} <- TileList],
    case TileList of
        [] ->
            CfgTileErl = lists:concat(["get_map_ref(_MapId) ->\n",
                                       "    [].\n\n"]);
        _ ->
            CfgTileErl = lists:concat(["get_map_ref(",MapId,") ->\n",
                                       "    [",string:join(CfgTileErlList, ",\n     "),"];\n",
                                       "get_map_ref(_MapId) ->\n",
                                       "    [].\n\n"])
    end,
    file:write_file(CfgMapErl,erlang:list_to_binary(CfgTileErl), [append]),
    
    %% 地图格子slice
    [begin 
         SliceName = mod_map_slice:get_slice_name_by_txty(STileX, STileY, OffsetX, OffsetY),
         Slice9List =[ lists:concat(["\"",PSliceName,"\""]) 
                     || PSliceName <- mod_map_slice:get_9_slice_by_txty(STileX, STileY, OffsetX, OffsetY, Width, Height)],
         Slice16List =[ lists:concat(["\"",PSliceName,"\""]) 
                     || PSliceName <- mod_map_slice:get_16_slice_by_txty(STileX, STileY, OffsetX, OffsetY, Width, Height)],
         CfgSliceErl = lists:concat(["get_slice_name({",STileX,",",STileY,"}) ->\n",
                                     "    [{r_map_slice,",STileX,",",STileY,",",STileType,",\"",SliceName,"\",[",string:join(Slice9List, ","),"],[",string:join(Slice16List, ","),"]}];\n"]),
         file:write_file(CfgMapErl,erlang:list_to_binary(CfgSliceErl), [append]),
         ok
     end || #r_map_ref{type=STileType,tx=STileX,ty=STileY} <- TileList],
    
    CfgSliceErlEnd=lists:concat(["get_slice_name(_) ->\n",
                                 "    [].\n\n"]),
    file:write_file(CfgMapErl, erlang:list_to_binary(CfgSliceErlEnd), [append]),
    
    %% 地图怪物
    CfgMonsterList = [lists:concat(["{r_map_res,",MapId,",",MResType,",",MResId,",",MResTx,",",MResTy,",0,",MResExtra,"}"]) 
                        || #r_map_res{res_type=MResType,res_id=MResId,tx=MResTx,ty=MResTy,extra=MResExtra} <- ResPosList,
                           MResType =:= ?MAP_ELEMENT_MONSTER_POINT],
    case CfgMonsterList of
        [] ->
            CfgMonsterErl=lists:concat(["get_map_monster(_MapId) ->\n",
                                        "    [].\n\n"]);
        _ ->
            CfgMonsterErl = lists:concat(["get_map_monster(",MapId,") ->\n",
                                          "    [",string:join(CfgMonsterList, ",\n     "),"];\n",
                                          "get_map_monster(_MapId) ->\n",
                                          "    [].\n\n"])
    end,
    file:write_file(CfgMapErl, erlang:list_to_binary(CfgMonsterErl), [append]),
    %% 地图跳转点
    lists:foldl(
      fun(#r_map_res{res_type=JResType,res_id=JResId,tx=JResTx,ty=JResTy,extra=JResExtra},AccCheckJumpList) ->
              case JResType=:= ?MAP_ELEMENT_JUMP_POINT 
                       andalso lists:member({MapId,JResTx,JResTy}, AccCheckJumpList) =:= false of
                  true ->
                      {JDestMapId,JDestTx,JDestTy} = JResExtra, 
                      {JumpTx,JumpTy} = mod_map_slice:to_tile_pos(JResTx, JResTy),
                      %% 自动生成一个以此点有中心的一个3x3的跳转点区域
                      JumpAreaTileList = 
                          lists:flatten([[{JumpAreaX,JumpAreaY} 
                                         || JumpAreaY  <- lists:seq(JumpTy - 2, JumpTy + 2)]
                                        || JumpAreaX <- lists:seq(JumpTx - 2, JumpTx + 2)]),
                      JumpPosList = [{PJumpAreaTx,PJumpAreaTy} 
                                    || {PJumpAreaTx,PJumpAreaTy} <- JumpAreaTileList,
                                       (lists:member(#r_map_ref{type=?MAP_REF_TYPE_WALK,tx=PJumpAreaTx,ty=PJumpAreaTy}, TileList) == true
                                       orelse lists:member(#r_map_ref{type=?MAP_REF_TYPE_NOT_WALK,tx=PJumpAreaTx,ty=PJumpAreaTy}, TileList) == true)],
                      
                      [begin
                           CfgJumpErl=lists:concat(["get_map_jump({",MapId,",",PJumpTx,",",PJumpTy,"}) ->\n",
                                               "    [{r_map_res,",MapId,",",JResType,",",JResId,",",JResTx,",",JResTy,",0,{",JDestMapId,",",JDestTx,",",JDestTy,"}}];\n"]),
                           file:write_file(CfgMapErl, erlang:list_to_binary(CfgJumpErl), [append]),
                           ok
                           end || {PJumpTx,PJumpTy} <- JumpPosList],
                      [{MapId,JResTx,JResTy}|AccCheckJumpList];
                  _ ->
                      AccCheckJumpList
              end
      end,[],ResPosList),
    CfgJumpErlEnd = lists:concat(["get_map_jump(_Info)-> \n",
                                  "    [].\n\n"]),
    file:write_file(CfgMapErl, erlang:list_to_binary(CfgJumpErlEnd), [append]),
    io:format("map config file gen succ,path=~s~n", [CfgMapErl]),
    ok.

