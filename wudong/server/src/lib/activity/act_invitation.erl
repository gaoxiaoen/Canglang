%%%-------------------------------------------------------------------
%%% @author lbq
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% �����ټ�(������)
%%% @end
%%% Created : 07. ���� 2018 11:06
%%%-------------------------------------------------------------------
-module(act_invitation).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("charge.hrl").

-define(INVITE_LEN, 6).

%% API
-export([init/1, get_new_invite_code/1, get_info/1, use_invitation/2, add_charge/2,get_state/0]).

init(#player{key = Pkey,nickname = NickName} = Player) ->
    St = activity_load:dbget_player_invite_code(Pkey,NickName),
    lib_dict:put(?PROC_STATUS_ACT_INVITATION, St),
    Player.

get_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_ACT_INVITATION),
    #st_act_invitation{
        invite_code = InviteCode,
        get_list = GetList,
        invite_num = InviteNum,
        be_invited = BeInvited
    } = St,
    Ids = data_act_invitation:get_all(),
    F = fun(Id) ->
        case data_act_invitation:get(Id) of
            [] -> [];
            Base ->
                GetState =
                    if InviteNum < Base#base_act_invitation.num -> 0;
                        true ->
                            case lists:member(Id, GetList) of
                                true -> 2;
                                false -> 1
                            end
                    end,
                [[
                    Base#base_act_invitation.id,
                    GetState,
                    Base#base_act_invitation.num,
                    Base#base_act_invitation.gold,
                    Base#base_act_invitation.type,
                    Base#base_act_invitation.ratio
                ]]
        end
    end,
    List = lists:flatmap(F, Ids),
    {InviteCode, InviteNum, BeInvited, List}.


use_invitation(Player, Str) ->
    St = lib_dict:get(?PROC_STATUS_ACT_INVITATION),
    #st_act_invitation{
        invite_code = InviteCode,
        be_invited = MyBeInvited
    } = St,
    if
        InviteCode == Str -> {20, Player};
        MyBeInvited >= 1 -> {21, Player};
        true ->
            ?DEBUG("Str ~p~n",[Str]),
            Sql = io_lib:format("select pkey from player_invite_code  where invite_code='~s'", [util:term_to_string(Str)]),
            case db:get_row(Sql) of
                [Pkey] ->
                    Myst = St#st_act_invitation{be_invited = max(St#st_act_invitation.be_invited, 1),use_invited_code = Str,use_invited_key = Pkey},
                    lib_dict:put(?PROC_STATUS_ACT_INVITATION, Myst),
                    activity_load:dbup_player_invite_code(Myst),
                    {1, Player};
                O ->
                    ?DEBUG("o ~p~n",[O]),
                    {0, Player}
            end
    end.

add_charge(Player, Val) ->
    St = lib_dict:get(?PROC_STATUS_ACT_INVITATION),
    #st_act_invitation{
        get_list = GetList,
        use_invited_code = UseInvitedCode,
        invite_num = InviteNum,
        be_invited = BeInvited
    } = St,
    if BeInvited == 1 ->
        {Title, Content} = t_mail:mail_content(175),
        mail:sys_send_mail([Player#player.key], Title, Content, [{10106, Val}]),
        Sql = io_lib:format("select pkey,invite_code,be_invited,get_list,invite_num,key_list,use_invited_code,use_invited_key,nickname from player_invite_code  where invite_code='~s'", [util:term_to_string(UseInvitedCode)]),
        case db:get_row(Sql) of
            [OPkey, OInviteCode1, OBeInvited, OGetList, OInviteNum,OKeyList,OUseInvitedCode,OUseInvitedKey,ONickName0] ->
                case player_util:get_player_pid(OPkey) of
                        false ->
                            NewSt1 =
                                #st_act_invitation{
                                    pkey = OPkey,
                                    nickname  = ONickName0,
                                    invite_num = OInviteNum + 1,
                                    invite_code = util:bitstring_to_term(OInviteCode1),
                                    get_list = util:bitstring_to_term(OGetList),
                                    key_list = [Player#player.key|util:bitstring_to_term(OKeyList)],
                                    use_invited_code = util:bitstring_to_term(OUseInvitedCode),
                                    use_invited_key = OUseInvitedKey,
                                    be_invited = OBeInvited
                                },
                            activity_load:dbup_player_invite_code(NewSt1);
                        Pid -> Pid ! {update_invitation_num,Player#player.key}
                end;
                Other ->
                    ?DEBUG("Other ~p~n",[Other]),
                    skip
        end,
        NewBeInvited = 2;
        true -> NewBeInvited = BeInvited
    end,
    F = fun(Id) ->
        case check_id(Id, Val, InviteNum, GetList) of
            false -> [];
            {true, _Base} -> [Id]
        end
    end,
    Ids = lists:flatmap(F, data_act_invitation:get_all()),
    UseIds = ?IF_ELSE(Ids == [], [], [hd(Ids)]),
    NewIds = UseIds ++ GetList,
    NewSt = St#st_act_invitation{get_list = NewIds, be_invited = NewBeInvited},
    lib_dict:put(?PROC_STATUS_ACT_INVITATION, NewSt),
    activity_load:dbup_player_invite_code(NewSt), %% ��д��
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    ?DEBUG("UseIds ~p~n",[UseIds]),
    F1 = fun(Id) -> %% �ٷ�����
        Base = data_act_invitation:get(Id),
        if
            Base#base_act_invitation.type == 1 ->
                {Title1, Content1} = t_mail:mail_content(176),
                Content2 = io_lib:format(Content1, [Base#base_act_invitation.num,Base#base_act_invitation.ratio]),
                mail:sys_send_mail([Player#player.key], Title1, Content2, [{10106, util:floor(max(0, (Val * Base#base_act_invitation.ratio) div 100  ))}]);
            true ->
                {Title1, Content1} = t_mail:mail_content(177),
                Content2 = io_lib:format(Content1, [Base#base_act_invitation.num,Base#base_act_invitation.ratio]),
                mail:sys_send_mail([Player#player.key], Title1, Content2, [{10106, util:floor(max(0, (ChargeSt#st_charge.total_gold * Base#base_act_invitation.ratio)) div 100)}])
        end
    end,
    lists:foreach(F1, UseIds),
    ok.

%% ��ȡ��������
get_new_invite_code(Pkey) ->
    MyInvitecode = lists:sublist(util:md5(lists:concat([Pkey, ?INVITE_CODE])), ?INVITE_LEN),
    ?DEBUG("MyInvitecode ~p~n", [MyInvitecode]),
    MyInvitecode.


check_id(Id, Val, Num, GetList) ->
    case lists:member(Id, GetList) of
        true -> false;
        false ->
            case data_act_invitation:get(Id) of
                [] ->
                    false;
                Base ->
                    if
                        Base#base_act_invitation.num > Num -> false;
                        Base#base_act_invitation.gold > Val -> false;
                        true ->
                            {true, Base}
                    end
            end
    end.


get_state()->
    Lan = version:get_lan_config(),
    if
        Lan ==  vietnam -> 0;
        true -> -1
    end.

