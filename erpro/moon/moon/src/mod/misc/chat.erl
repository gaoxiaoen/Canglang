%----------------------------------------------------
%%  聊天相关远程调用
%% @author wpf(wprehard@qq.com)
%%----------------------------------------------------
-module(chat).
-export([
        ban/3
        ,to_realm/1
        ,chat_kuafu/1
        ,get_chat_frame/1
        ,get_text_style/1
        ,get_face_group/1
        ,update_face_group_order/2
        ,push_face_group/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("chat_rpc.hrl").
-include("item.hrl").
-include("setting.hrl").
-include("sns.hrl").

-define(CHAT_CIRCLE_BAN_LEV, 30).
% -define(CHAT_SCENE_BAN_LEV, 41).

%% @spec ban(Type, Text, Role) -> any()
%% @doc 处理新手区广告/晶钻屏蔽词的聊天内容
%% 场景屏蔽
ban(scene, Msg, #role{id = {Rid, SrvId}, name = Name, sex = Sex, pos = #pos{map_pid = MapPid}, 
        vip = #vip{type = Vip}})->
    % L = filter_data:get_ban_scene(),
    % % FaceGroups = get_face_group(Role),
    % case util:text_banned(Msg, L) of
    %     true -> %% 含有屏蔽词
    %         sys_conn:pack_send(ConnPid, 10910, {?chat_map, Rid, SrvId, Name, Sex, Vip, [], [], Msg});
    %     false ->
    %         map:pack_send_to_all(MapPid, 10910, {?chat_map, Rid, SrvId, Name, Sex, Vip, [], [], Msg})
    % end;

    Msg1 = forbid_word_filter:filter(Msg),
    % Msg1 = Msg,
    map:pack_send_to_all(MapPid, 10910, {?chat_map, Rid, SrvId, Name, Sex, Vip, [], [], Msg1});

% ban(scene, Msg, #role{id = {Rid, SrvId}, name = Name, sex = Sex, pos = #pos{map_pid = MapPid}, 
%         vip = #vip{type = Vip}}) ->
%     map:pack_send_to_all(MapPid, 10910, {?chat_map, Rid, SrvId, Name, Sex, Vip, [], [], Msg});


%% old
%% 世界屏蔽
%%ban(world, Msg, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, lev = Lev, sex = Sex, vip = #vip{type = Vip},
%%        link = #link{conn_pid = ConnPid}}) when Lev =< ?CHAT_SCENE_BAN_LEV ->
%%    L = filter_data:get_ban_scene(),
%%    FaceGroups = get_face_group(Role),
%%    case util:text_banned(Msg, L) of
%%        true -> %% 含有屏蔽词
%%            sys_conn:pack_send(ConnPid, 10910, {?chat_world, Rid, SrvId, Name, Sex, Vip, [Label, to_realm(Realm), get_chat_frame(Role)], FaceGroups, Msg});
%%        false ->
%%            role_group:pack_cast(world, 10910, {?chat_world, Rid, SrvId, Name, Sex, Vip, [Label, to_realm(Realm), get_chat_frame(Role)], FaceGroups, Msg})
%%    end;
%%ban(world, Msg, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, sex = Sex, vip = #vip{type = Vip}}) ->
%%    FaceGroups = get_face_group(Role),
%%    role_group:pack_cast(world, 10910, {?chat_world, Rid, SrvId, Name, Sex, Vip, [Label, to_realm(Realm), get_chat_frame(Role)], FaceGroups, Msg});

%% by bwang
ban(world, Msg,  #role{id = {Rid, SrvId}, pid = Pid, name = Name, sex = Sex, link = #link{conn_pid = ConnPid}, vip = #vip{type = Vip}
        }) ->
   %  L = filter_data:get_ban_scene(),
   % %% FaceGroups = get_face_group(Role),
   %  case util:text_banned(Msg, L) of
   %      true -> %% 含有屏蔽词
   %          sys_conn:pack_send(ConnPid, 10910, {?chat_world, Rid, SrvId, Name, Sex, Vip, [], [], Msg});
   %      false ->
   %          % io:format("ban world 1 Msg:~p~n",[Msg]),
   %          case ets:lookup(shield_world_chat,Pid) of 
   %              [] ->
   %                  role_group:pack_cast(world_chat, 10910, {?chat_world, Rid, SrvId, Name, Sex, Vip, [], [], Msg});
   %              [{Pid, _}] ->
   %                  notice:alert(error, ConnPid, ?MSGID(<<"你屏蔽世界聊天啦，取消才能世界聊吖">>))
   %          end
   %  end;
    Msg1 = forbid_word_filter:filter(Msg),
    % Msg1 = Msg,
    case ets:lookup(shield_world_chat, Pid) of 
        [] ->
            role_group:pack_cast(world_chat, 10910, {?chat_world, Rid, SrvId, Name, Sex, Vip, [], [], Msg1});
        [{Pid, _}] ->
            notice:alert(error, ConnPid, ?MSGID(<<"你屏蔽世界聊天啦，取消才能世界聊吖">>))
    end;

% ban(world, Msg,  #role{id = {Rid, SrvId}, name = Name,  sex = Sex}) ->
%    %% FaceGroups = get_face_group(Role),
%     % io:format("ban world2 Msg:~p~n",[Msg]),
%     role_group:pack_cast(world_chat, 10910, {?chat_world, Rid, SrvId, Name, Sex, 0, [], [], Msg});


%% 私聊
ban(circle, Msg, #role{lev = Lev}) when Lev =< ?CHAT_CIRCLE_BAN_LEV ->
    L = filter_data:get_ban_scene(),
    case util:text_banned(Msg, L) of
        true -> %% 含有屏蔽词
            ignore;
        false ->
            ok
    end;
%% 私聊
ban(circle2, Msg, _Role)  ->
    L = filter_data:get_ban_scene(),
    case util:text_banned(Msg, L) of
        true -> %% 含有屏蔽词
            ignore;
        false ->
            ok
    end;
ban(_, _, _) -> ok.

%% 阵营转换特殊标签
to_realm(?role_realm_default) -> 10;
to_realm(?role_realm_a) -> 11;
to_realm(?role_realm_b) -> 12.

%% 获取聊天框
get_chat_frame(#role{eqm = Eqm, setting = #setting{dress_looks = #dress_looks{chat_frame = 1}}}) ->
    get_chat_frame(Eqm);
get_chat_frame(Eqm) when is_list(Eqm) ->
    get_chat_frame(lists:keyfind(?item_chat_frame, #item.type, Eqm));
get_chat_frame(#item{base_id = BaseId}) -> BaseId;
get_chat_frame(_) -> 0.

%% 获取炫酷文字
get_text_style(#role{eqm = Eqm}) ->
    get_text_style(Eqm);
get_text_style(Eqm) when is_list(Eqm) ->
    get_text_style(lists:keyfind(?item_text_style, #item.type, Eqm));
get_text_style(#item{base_id = BaseId}) -> BaseId;
get_text_style(_) -> 0.

%% 跨服聊天群组消息广播
chat_kuafu(DataMsg) ->
    List = ets:tab2list(ets_kuafu_friend_roles),
    lists:foreach(
        fun({{Rid, SrvId}, ?true, _, _}) ->
                case global:whereis_name({role, Rid, SrvId}) of
                    Pid when is_pid(Pid) ->
                        role:pack_send(Pid, 10910, DataMsg);
                    _ -> ignore
                end;
            (_) -> ignore
        end, List).

%% @spec get_face_group(#role{}) -> [integer()]
%% @doc 获取聊天包列表
get_face_group(#role{sns = #sns{face_group = Faces}}) ->
    Now = util:unixtime(),
    [Id || {Id, IsPersistent, Expire, _Order} <- Faces, IsPersistent =:= 1 orelse Expire > Now].

%% @spec update_face_group_order(Role, Orders) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% Orders = [{Id::integer(), Order::integer()}]
%% Reason = bitstring()
%% @doc 调整表情包顺序
update_face_group_order(Role = #role{sns = Sns = #sns{face_group = Faces}}, Orders) ->
    NewFaces = do_face_group_order(Orders, Faces),
    NewRole = Role#role{sns = Sns#sns{face_group = NewFaces}},
    push_face_group(NewRole),
    {ok, NewRole}.

do_face_group_order([], Faces) ->
    Faces;
do_face_group_order([[Id, Order] | T], Faces) ->
    case lists:keyfind(Id, 1, Faces) of
        {_Id, _IsPersistent, _Expire, Order} -> 
            do_face_group_order(T, Faces);
        {Id, IsPersistent, Expire, _} -> 
            NewFaces = lists:keyreplace(Id, 1, Faces, {Id, IsPersistent, Expire, Order}),
            do_face_group_order(T, NewFaces);
        _ ->
            do_face_group_order(T, Faces)
    end;
do_face_group_order([_H | T], Faces) ->
    do_face_group_order(T, Faces).

%% 推送10972协议
push_face_group(#role{sns = #sns{face_group = Faces}, link = #link{conn_pid = ConnPid}}) ->
    Now = util:unixtime(),
    Data =  [{Id, IsPersistent, max(0, Expire - Now), Order} || {Id, IsPersistent, Expire, Order} <- Faces],
    sys_conn:pack_send(ConnPid, 10972, {Data}).
