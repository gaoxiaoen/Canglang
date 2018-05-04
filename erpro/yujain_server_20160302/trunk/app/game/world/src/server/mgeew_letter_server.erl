%%%-------------------------------------------------------------------
%%% File        :mgeew_letter_server.erl
%%% @doc
%%%     信件模块
%%% @end
%%%-------------------------------------------------------------------
-module(mgeew_letter_server).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files 
%% --------------------------------------------------------------------
-include("mgeew.hrl"). 
%% --------------------------------------------------------------------
%% External exports
-export([start/0,
		 start_link/0,
		 
		 create_db_common_letter/3,
		 create_db_common_letter/4
		 ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% External functions
%% ====================================================================

start()->
    {ok,_} = supervisor:start_child(mgeew_sup,{?MODULE,
                                               {?MODULE,start_link,[]},
                                               permanent, 30000, worker,
                                               [?MODULE]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ====================================================================
%% Server functions
%% ====================================================================

init([]) ->
    {ok,[]}.


handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Request, State) ->
    {noreply,  State}.

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(Reason, State) ->
    {stop,Reason, State}.

code_change(_Request,_Code,_State)->
    ok.


%% ====================================================================
%%% Internal functions
%% ====================================================================


%% ================玩家信件=========================
%%发送私人信件到地图处理数据 
do_handle_info({_Module, ?LETTER_P2P_SEND, DataIn, RoleId, PId, _}) ->
    do_letter_p2p_send(RoleId,DataIn,PId);

%% 获取全部信件，登录时推送
do_handle_info({_Module, ?LETTER_GET, _, _, _, _}=Msg) ->
    do_get_all_letter(Msg);

%%打开信件 
do_handle_info({_Module, ?LETTER_OPEN, _, _, _, _}=Msg) ->
    do_open_letter(Msg);

%%获取物品
do_handle_info({_Module, ?LETTER_ACCEPT_GOODS, _, _, _, _}=Msg) ->
    do_check_accept_goods(Msg);

%%删除信件
do_handle_info({_Module, ?LETTER_DELETE, _, _, _, _}=Msg) ->
    do_delete_letter(Msg);

%%返回私人信件数据在这边写入
do_handle_info({send_p2p_letter_succ,Info})->
    do_send_p2p_letter_succ(Info);

%%返回获取物品
%%数据库数据字段修改
%%清楚进程字典
do_handle_info({accept_goods_succ,RoleId,DataIn,NewGoodsList})->
    do_accept_goods_succ(RoleId,DataIn,NewGoodsList);
do_handle_info({accept_goods_fail,RoleId,DataIn})->
    do_accept_goods_fail(RoleId,DataIn);

%% =========================系统信件=================================
%%发送系统信件 GoodsList=[#p_goods,..]
do_handle_info({send_sys2p,RoleId,Title,Text,GoodsList,Days, StartTime}) ->
    do_send_letter(RoleId,Title,Text,GoodsList,Days,StartTime,common_lang:get_lang(100101),?TYPE_LETTER_SYSTEM);
do_handle_info({send_sys2single,RoleId,Title,Text,GoodsList})->
    do_send_letter(RoleId,Title,Text,GoodsList,3,common_tool:now(),common_lang:get_lang(100102),?TYPE_LETTER_GM);

%% 后台管理发送信件
do_handle_info({admin_send_goods,Info}) ->
    do_admin_send_goods(Info);

%% 专门用来分段群发    
do_handle_info({split,RoleIdList,LetterDetail,LogLetterInfo,Gold,Silver,Coin,AllCount})->
    do_sys2common_letter_split(RoleIdList,LetterDetail,LogLetterInfo,Gold,Silver,Coin,AllCount);

%% 玩家每次登陆都请除一遍数据表中的数据    done 
do_handle_info({clean_letter,RoleId})->
    do_clean_letter(RoleId);

do_handle_info({role_offline,RoleId})->
    erase_accept_goods_lock(RoleId).
%%=========================================================================== 


%%=======================================================================
%%---------------- manager ----------------------------------------------
%%=======================================================================
%% 人对人发送信件
 do_letter_p2p_send(RoleId,DataIn,PId)->
     Counter = get_role_letter_counter(RoleId),
     case Counter >= ?LIMIT_SEND_LETTER_COUNT of
         true->
             SendSelf = #m_letter_send_toc{op_code=?_RC_LETTER_P2P_SEND_000,op_reason=""},
             common_misc:unicast(PId,?LETTER,?LETTER_P2P_SEND,SendSelf);
         false->
             common_misc:send_to_role(RoleId, {mod,mod_letter,{send_p2p,RoleId,DataIn,PId}})
     end.
            

%% 玩家获取全部信件------------------
do_get_all_letter({Module, Method, _DataIn, RoleId, PId, _Line})->
    RoleLetter = get_role_letter(RoleId),
    #r_role_letter{letter_list=LetterList} = RoleLetter,
    TocLetterList=[transfer_to_toc(LetterInfo)||LetterInfo<-LetterList],
    LetterListToc = #m_letter_get_toc{letters =TocLetterList},
    common_misc:unicast(PId, Module, Method, LetterListToc).


%% 玩家打开一封信件-------------------
do_open_letter({Module, Method, DataIn, RoleId, PId, _Line})->
    case catch can_open_letter(DataIn,RoleId) of
        {ok,TocLetterInfo}->
            SendSelf = #m_letter_open_toc{op_code=0,result=TocLetterInfo};
        {error,OpReason,OpCode}->
            SendSelf = #m_letter_open_toc{op_code=OpCode,op_reason=OpReason}
    end,
    common_misc:unicast(PId,Module,Method,SendSelf).
  
can_open_letter(DataIn,RoleId)->
    #m_letter_open_tos{letter_id=Id} = DataIn,
    RoleLetter = get_role_letter(RoleId),
    case lists:keyfind(Id, #r_letter_info.id, RoleLetter#r_role_letter.letter_list) of
        false->
            erlang:throw({error,"",?_RC_LETTER_OPEN_000}),
            LetterInfo=undefined;
        LetterInfo->
            next
    end,
    case LetterInfo#r_letter_info.state of
        ?LETTER_HAS_OPEN->
            ignore;
        _->
            LetterList=lists:keyreplace(Id, #r_letter_info.id, RoleLetter#r_role_letter.letter_list, LetterInfo#r_letter_info{state=?LETTER_HAS_OPEN}),
            set_role_letter(RoleLetter#r_role_letter{letter_list=LetterList})
    end,
    Text = 
        case LetterInfo#r_letter_info.content_type of
            ?LETTER_CONTENT_CHAR->LetterInfo#r_letter_info.content;
            ?LETTER_CONTENT_COMMON->get_common_letter_content(LetterInfo#r_letter_info.content);
            ?LETTER_CONTENT_TEMPLATE->get_template_letter_content(LetterInfo#r_letter_info.content)
        end,
                              
    {ok,#p_letter_info{id   = LetterInfo#r_letter_info.id,
                   sender   = LetterInfo#r_letter_info.role_name,
                   receiver = LetterInfo#r_letter_info.role_name,
                   title    = LetterInfo#r_letter_info.title,       
                   send_time  = LetterInfo#r_letter_info.send_time,   
                   type       = LetterInfo#r_letter_info.type,     
                   state      = LetterInfo#r_letter_info.state,     
                   goods_list = LetterInfo#r_letter_info.goods_list,
                   letter_content = Text,
                   is_send=LetterInfo#r_letter_info.is_send}}.

get_common_letter_content(Id)->
    case db_api:dirty_read(?DB_COMMON_LETTER,Id) of
        [#r_common_letter{text=Text}]->Text;
        _->""
    end.

get_template_letter_content({Id,List})->
    common_lang:get_json_lang(Id, List).
    

%%@doc （后台赠送元宝后）发送的系统邮件-----------------------------


%% 抽取出来方便以后做优化 缓存之类的
get_role_letter(RoleId)->
    case db_api:dirty_all_read(?DB_ROLE_LETTER, RoleId) of
        [RoleLetter]->
            RoleLetter;
        _-> 
            case mod_role:get_role_base(RoleId) of
                {ok,#p_role_base{role_name = RoleName}} ->
                    next;
                _ ->
                    case db_api:dirty_all_read(?DB_ROLE_BASE, RoleId) of
                        [#p_role_base{role_name=RoleName}]->
                            next;
                        _->
                            RoleName = ""
                    end
            end,
            #r_role_letter{role_id=RoleId,role_name=RoleName}
    end.

set_role_letter(RoleLetter)->
    db_api:dirty_write(?DB_ROLE_LETTER,RoleLetter).

%% 一封信
set_role_letter(RoleId,LetterInfo)->
    RoleLetter = get_role_letter(RoleId),
    NewCount =RoleLetter#r_role_letter.count+1,
    NewLetterInfo = LetterInfo#r_letter_info{id=NewCount},
    NewLetterListT = [NewLetterInfo|RoleLetter#r_role_letter.letter_list],
    NewLetterList =
    case erlang:is_list(NewLetterListT) > 50 of
        true->
            lists:sublist(NewLetterListT, 50);
        false->
            NewLetterListT
    end,
    NewRoleLetter = RoleLetter#r_role_letter{count=NewCount,letter_list=NewLetterList},
    db_api:dirty_all_write(?DB_ROLE_LETTER, NewRoleLetter),
    NewLetterInfo.

%% 玩家向玩家发送信件------------------
do_send_p2p_letter_succ({SendId,SendName,RecvId,RecvName,Text,GoodsListT})->
    add_role_letter_counter(SendId),
    {GoodsList,_} = 
        lists:foldl(
            fun(Goods,{AccGoodsList,AccId})->
                    {[Goods#p_goods{id=AccId}|AccGoodsList],AccId+1}
            end, {[],1}, GoodsListT),
    {SendTime,OutTime} = common_letter:get_effective_time(),
    RecverLetterInfo = #r_letter_info{role_id=SendId,role_name=SendName,
                                      send_time=SendTime,out_time=OutTime,
                                      content_type = ?LETTER_CONTENT_CHAR,
                                      title = "",content = Text,goods_list= GoodsList,
                                      state = ?LETTER_NOT_OPEN,type= ?TYPE_LETTER_PRIVATE,
                                      is_send=false},
    SenderLetterInfo = #r_letter_info{role_id=RecvId,role_name=RecvName,
                                      send_time = SendTime,out_time=OutTime,
                                      content_type = ?LETTER_CONTENT_CHAR,
                                      title = "",content= Text,goods_list= GoodsList,
                                      state = ?LETTER_HAS_OPEN,type = ?TYPE_LETTER_PRIVATE,
                                      is_send=true},
    RecverLetterInfo2=set_role_letter(RecvId,RecverLetterInfo),
    SenderLetterInfo2=set_role_letter(SendId,SenderLetterInfo),
    RecvLetterToc = transfer_to_toc(RecverLetterInfo2),
    SendLetterToc = transfer_to_toc(SenderLetterInfo2),
    common_misc:unicast({role,SendId}, ?LETTER, ?LETTER_SEND,#m_letter_send_toc{op_code=0,letter=SendLetterToc}),
    common_misc:unicast({role,RecvId}, ?LETTER, ?LETTER_SEND,#m_letter_send_toc{op_code=0,letter=RecvLetterToc}).
 

%% 玩家检查获取物品-------------------------
do_check_accept_goods({_Module, _Method, DataIn, RoleId, PId, _Line}) ->      
    case catch can_accept_goods(RoleId,DataIn) of
        {ok,LetterInfo}->
            set_accept_goods_lock(RoleId,true),
            common_misc:send_to_role(RoleId,{mod,mod_letter,{accept_goods,DataIn,RoleId,PId,LetterInfo}});
        {error,OpReason,OpCode}->
            SendSelf =#m_letter_accept_goods_toc{op_code = OpCode,
                                                 op_reason = OpReason,
                                                 letter_id = DataIn#m_letter_accept_goods_tos.letter_id,
                                                 goods_id = DataIn#m_letter_accept_goods_tos.goods_id
                                                }, 
            common_misc:unicast(PId, ?LETTER, ?LETTER_ACCEPT_GOODS,SendSelf)
    end.

-define(letter_accept_goods_lock,letter_accept_goods_lock).
get_accept_goods_lock(RoleId)->
    erlang:get({?letter_accept_goods_lock,RoleId}).

set_accept_goods_lock(RoleId,Val)->
    erlang:put({?letter_accept_goods_lock,RoleId},Val).

erase_accept_goods_lock(RoleId)->
    erlang:erase({?letter_accept_goods_lock,RoleId}).

can_accept_goods(RoleId,DataIn)->
    #m_letter_accept_goods_tos{letter_id=LetterId,
                               goods_id=GoodsId}=DataIn,
    case get_accept_goods_lock(RoleId) of
        true->
            erlang:throw({error,"",?_RC_LETTER_ACCEPT_GOODS_000});
        _->
            ignore
    end,
    RoleLetter=get_role_letter(RoleId),
    case lists:keyfind(LetterId, #r_letter_info.id, RoleLetter#r_role_letter.letter_list) of
        false->
            erlang:throw({error,"",?_RC_LETTER_ACCEPT_GOODS_001}),
            LetterInfo=undefined;
        LetterInfo->
            next
    end,
    #r_letter_info{is_send=IsSend,goods_list=GoodsList} = LetterInfo,
    case IsSend=:=true of
        true->erlang:throw({error,"",?_RC_LETTER_ACCEPT_GOODS_001});
        _->next
    end,
    case GoodsList =:= [] of
        true-> erlang:throw({error,"",?_RC_LETTER_ACCEPT_GOODS_001});
        false->
            next
    end,
    case erlang:is_integer(GoodsId) of
        true->
           next;
        _ ->
            erlang:throw({error,"",?_RC_LETTER_ACCEPT_GOODS_003})
    end,
    case GoodsId =:=0 orelse lists:keyfind(GoodsId, #p_goods.id, GoodsList) =/=false of
        true ->
            next;
        _ ->
            erlang:throw({error,"",?_RC_LETTER_ACCEPT_GOODS_002})
    end,
    {ok,LetterInfo}.
    
do_accept_goods_succ(RoleId,DataIn,NewGoodsList)->
    erase_accept_goods_lock(RoleId),
    RoleLetter = get_role_letter(RoleId),
    #m_letter_accept_goods_tos{letter_id=LetterId} = DataIn,
    case lists:keyfind(LetterId, #r_letter_info.id, RoleLetter#r_role_letter.letter_list) of
        false->
            ignore;
        LetterInfo->
            NewLetterInfo = LetterInfo#r_letter_info{goods_list=NewGoodsList},
            NewLetterList= lists:keyreplace(LetterInfo#r_letter_info.id, #r_letter_info.id, RoleLetter#r_role_letter.letter_list, NewLetterInfo),
            set_role_letter(RoleLetter#r_role_letter{letter_list=NewLetterList})
    end.

do_accept_goods_fail(RoleId,_DataIn)->
    erase_accept_goods_lock(RoleId).


%% 群发信件  不需要返回-------------------------
do_admin_send_goods({RoleIdList,Title,Text,Gold,Silver,Coin,GoodsList})->
    Now = common_tool:now(),
    RoleIdList1 = lists:filter(fun(RoleId)-> if_can_accept_system_letter(RoleId, Now) end, RoleIdList),
    %% 修改为分段发送
    %% 截取roleidlist 
    {SendTime,OutTime} = common_letter:get_effective_time(),
    %% 获取公共信件内容索引
    case Text of
        {_,_} ->
            Content = Text,
            ContentType = ?LETTER_CONTENT_TEMPLATE;
        _-> 
            Content = create_db_common_letter(SendTime,OutTime,Title,common_tool:to_binary(Text)),
            ContentType = ?LETTER_CONTENT_COMMON
    end,  
    LetterInfo =#r_letter_info{role_name=common_lang:get_lang(100101), 
                               send_time=SendTime,out_time=OutTime, 
                               content_type=ContentType,content=Content,
                               title=Title,
                               goods_list=GoodsList, 
                               state=?LETTER_NOT_OPEN,
                               type=?TYPE_LETTER_GM,
                               is_send=false},
    AllCount = length(RoleIdList1),
    LogLetterInfo = #r_log_letter{sender_role_id = 99999999,sender_role_name = common_lang:get_lang(100101), sender_account_name = common_lang:get_lang(100102), 
                                  receiver_role_id = 0,receiver_role_name = "",receiver_account_name = "", 
                                  mtime = Now,is_system = 1,letter_type = ?TYPE_LETTER_SYSTEM,
                                  title = Title, content = Text, 
                                  gold = Gold, money = Silver,  
                                  coin = Coin,
                                  attachments = GoodsList,
                                  log_desc = ""},
    %% 分段发送
    do_sys2common_letter_split(RoleIdList1,LetterInfo,LogLetterInfo,Gold,Silver,Coin,AllCount).

%% 创建公共信件
create_db_common_letter(SendTime,OutTime,Text)->
    Title = common_lang:get_lang(100101),
    create_db_common_letter(SendTime,OutTime,Title,Text).
create_db_common_letter(SendTime,OutTime,Title,Text)->
	case db_api:dirty_read(?DB_COMMON_LETTER_COUNTER,1) of
		[CounterInfo] ->
			next;
		_ ->
			CounterInfo = #r_counter{key=1}
	end,
	NewCommonLetterId = CounterInfo#r_counter.last_id,
	db_api:dirty_write(?DB_COMMON_LETTER_COUNTER, CounterInfo#r_counter{last_id=NewCommonLetterId + 1}),
    CommonLetter = #r_common_letter{id = NewCommonLetterId,
                                    send_time = SendTime,
                                    out_time = OutTime,
                                    title = Title,
                                    text=Text},
    db_api:dirty_write(?DB_COMMON_LETTER,CommonLetter),
    NewCommonLetterId.

do_send_letter(RoleId,Title,Text,GoodsListT,Days,SendTime,RoleName,Type)->
    {_,OutTime} = common_letter:get_effective_time(SendTime, Days),
    %% 获取公共信件内容索引
    ContentType = 
        case Text of
            {_,_} ->?LETTER_CONTENT_TEMPLATE;
            _-> ?LETTER_CONTENT_CHAR
        end, 
    {GoodsList,_} = 
        lists:foldl(
            fun(Goods,{AccGoodsList,AccId})->
                    {[Goods#p_goods{id=AccId}|AccGoodsList],AccId+1}
            end, {[],1}, GoodsListT),
    LetterInfo= #r_letter_info{role_name=RoleName, 
                               send_time=SendTime,
                               out_time=OutTime, 
                               content_type=ContentType,
                               title=Title,
                               content=Text,
                               goods_list=GoodsList, 
                               state=?LETTER_NOT_OPEN,
                               type=Type,
                               is_send=false},
    LetterInfo2 = set_role_letter(RoleId,LetterInfo),
    LetterInfoToc = transfer_to_toc(LetterInfo2),
    common_misc:unicast({role,RoleId}, ?LETTER, ?LETTER_SEND,#m_letter_send_toc{op_code=0,letter=LetterInfoToc}),
    %% 记录日志
    case common_misc:get_role_base(RoleId) of
        {ok,#p_role_base{account_name = AccountName}} ->
            next;
        _ ->
            AccountName = ""
    end,
    LogTime = common_tool:now(),
    LogLetterInfo = #r_log_letter{sender_role_id = 99999999,sender_role_name = common_lang:get_lang(100101), sender_account_name = common_lang:get_lang(100102), 
                                  receiver_role_id = RoleId,receiver_role_name = RoleName,receiver_account_name = AccountName, 
                                  mtime = LogTime,is_system = 1,letter_type = Type,
                                  title = Title, content = Text, 
                                  gold = 0,money = 0,
                                  coin = 0, 
                                  attachments = GoodsList,
                                  log_desc = ""},
    common_log:log_letter(LogLetterInfo),
    ok.

%% 清除信件
do_clean_letter(RoleId)->
    RoleLetter = get_role_letter(RoleId),
    Now = common_tool:now(),
    {DelLetterList,LetterList} = 
        lists:foldr(
          fun(LetterInfo,{AccDelList,AccList})->
                  case Now > LetterInfo#r_letter_info.out_time of
                      false->
                          {AccDelList,[LetterInfo|AccList]};
                      true->
                          {[LetterInfo|AccDelList],AccList}
                  end
          end, {[],[]}, RoleLetter#r_role_letter.letter_list),
    case DelLetterList of
        []-> ignore;
        _-> set_role_letter(RoleLetter#r_role_letter{letter_list=LetterList}),
            do_send_back_letter(RoleId,RoleLetter#r_role_letter.role_name,DelLetterList)
    end.
                                           
    
%%删除信件 ------------------------------
%%如果要删除公共信件，先把信箱拿出来，把全部信件处理完再写回去
do_delete_letter({Module, Method, DataIn, RoleId, PId, _Line})->
    case catch can_delete_letter(RoleId,DataIn) of
        {ok,RoleLetter,DelLetterInfoList}->
            set_role_letter(RoleLetter),
            LetterIds = [Id||#r_letter_info{id=Id}<-DelLetterInfoList],
            SendSelf = #m_letter_delete_toc{letter_ids=LetterIds,op_code=0},
            common_misc:unicast(PId, Module, Method, SendSelf),
            do_send_back_letter(RoleId,RoleLetter#r_role_letter.role_name,DelLetterInfoList);
        {error,OpReason,OpCode}->
            SendSelf = #m_letter_delete_toc{op_code=OpCode,
                                            op_reason=OpReason,
                                            letter_ids = DataIn#m_letter_delete_tos.letter_ids},
            common_misc:unicast(PId, Module, Method, SendSelf)
    end.
          
do_send_back_letter(RoleId,RoleName,DelLetterInfoList)->
    lists:foreach(
      fun(LetterInfo)->
              case LetterInfo#r_letter_info.is_send of
                  true->
                      ignore;
                  false->
                      case LetterInfo#r_letter_info.goods_list=:=[] of
                          true->
                              ignore;
                          false->
                              case LetterInfo#r_letter_info.type=:=?TYPE_LETTER_PRIVATE of
                                  true->
                                      send_back_letter(RoleName,LetterInfo);
                                  false->
                                      case mod_role:get_role_base(RoleId) of
                                          {ok,RoleBase} ->
                                              next;
                                          _ ->
                                              case common_misc:get_role_base(RoleId) of
                                                  {ok,RoleBase} ->
                                                      next;
                                                  _ ->
                                                      RoleBase = undefined
                                              end
                                      end,
                                      case RoleBase of
                                          undefined ->
                                              next;
                                          _ ->
                                              LogTime = common_tool:now(),
                                              common_log:log_goods_list({RoleBase,?LOG_CONSUME_GOODS_LETTER_DELETE,LogTime,LetterInfo#r_letter_info.goods_list,""})
                                      end
                              end
                      end
              end
      end, DelLetterInfoList).

can_delete_letter(RoleId,DataIn)->
    #m_letter_delete_tos{letter_ids=LetterIds}=DataIn,
    case LetterIds of
        []->erlang:throw({error,"",?_RC_LETTER_DELETE_000});
        _->next
    end,
    
    Now = common_tool:now(),
    case get_accept_goods_lock(RoleId) of
        undefined->next;
        Seconds->
            case Now - Seconds < ?REQUEST_OVER_TIME of
                true->erlang:throw({error,"",?_RC_LETTER_DELETE_001});
                false->next
            end
    end,
    
    RoleLetter = get_role_letter(RoleId),
    {DelLetterList,LetterList} = 
        lists:foldr(
          fun(LetterInfo,{AccDelList,AccList})->
                  case lists:member(LetterInfo#r_letter_info.id, LetterIds) of
                      false->
                          {AccDelList,[LetterInfo|AccList]};
                      true->
                          {[LetterInfo|AccDelList],AccList}
                  end
          end, {[],[]}, RoleLetter#r_role_letter.letter_list),
    case DelLetterList of
        []->
            erlang:throw({error,"",?_RC_LETTER_DELETE_002});
        _->
            ignore
    end,
    {ok,RoleLetter#r_role_letter{letter_list=LetterList}, DelLetterList}.


%% --------------------end 删除私人信件

%% --------------------begin 退信
%% 只有删除  私人发送给你的  且带物品的  且物品为收的信件才会退信
%% 退回信件会将类型改为 ?TYPE_LETTER_RETURN 


send_back_letter(RoleName,LetterInfo)->
    {SendTime,OutTime} = common_letter:get_effective_time(),
    RecvId = LetterInfo#r_letter_info.role_id,
    BackLetterInfo = #r_letter_info{role_id=0,
                                    role_name=RoleName, 
                                    send_time=SendTime,
                                    out_time=OutTime, 
                                    content_type=?LETTER_CONTENT_TEMPLATE,
                                    title=common_lang:get_lang(100103),
                                    content={1800001,[]},
                                    goods_list=LetterInfo#r_letter_info.goods_list, 
                                    state=?LETTER_NOT_OPEN,
                                    type=?TYPE_LETTER_RETURN, 
                                    is_send=false},
    NewBackLetterInfo = set_role_letter(RecvId,BackLetterInfo),
    TocLetterInfo=transfer_to_toc(NewBackLetterInfo),
    common_misc:unicast({role,RecvId}, ?LETTER, ?LETTER_SEND,#m_letter_send_toc{op_code=0,letter=TocLetterInfo}).

%% ------------------end 退信

%% ===================================================================
%% -------------------- tool function --------------------------------
%% ===================================================================

%% 分段发送 ----------------------------------
do_sys2common_letter_split(RoleIdList,LetterInfo,LogLetterInfo,Gold,Silver,Coin,AllCount)->
    {RoleIDList1,RoleIDList2} =
        case length(RoleIdList) < ?ONE_TIME_SEND_MAX of
            true ->
                {RoleIdList,[]};
            false ->
                lists:split(?ONE_TIME_SEND_MAX,RoleIdList)
        end,
    lists:foreach(
      fun(RoleId)-> 
              case Gold =:= 0 andalso Silver =:= 0 of
                  true ->
                      next;
                  _ -> %% 加钱操作处理
                      do_admin_send_money(RoleId,Gold,Silver,Coin)
              end,
              
              LetterInfo2 = set_role_letter(RoleId,LetterInfo),
              TocLetterInfo = transfer_to_toc(LetterInfo2),
              common_misc:unicast({role,RoleId}, ?LETTER, ?LETTER_SEND,#m_letter_send_toc{op_code = 0,letter=TocLetterInfo}),
              case mod_role:get_role_base(RoleId) of
                  {ok,RoleBase} -> next;
                  _ ->
                      case db_api:dirty_all_read(?DB_ROLE_BASE, RoleId) of
                          [RoleBase] -> next;
                          _ -> 
                              RoleBase = undefined
                      end
              end,
              case RoleBase of
                    undefined -> ?ERROR_MSG("~ts,RoleId=~w",[?_LANG_LOCAL_001,RoleId]);
                    _ ->
                        #p_role_base{role_name = RoleName,account_name=AccountName} = RoleBase,
                        common_log:log_letter(LogLetterInfo#r_log_letter{receiver_role_id = RoleId,
                                                                         receiver_role_name = RoleName,
                                                                         receiver_account_name = AccountName})
              end
      end, RoleIDList1),
    ?ERROR_MSG("--------SEND COMMON LETTER RoleIdList :~w",[RoleIDList1]),
    case RoleIDList2 of
        [] ->
            next;
        _ ->
            erlang:send_after(?SEND_SPLIT_TIME,self(),{split,RoleIDList2,LetterInfo,LogLetterInfo,Gold,Silver,Coin,AllCount})
    end.
do_admin_send_money(RoleId,Gold,Silver,Coin) ->
    case common_misc:send_to_role(RoleId, {mod,mod_money,{admin_pay,{RoleId,Gold,Silver,Coin}}}) of
        ignore -> %% 玩家不在线处理
            case db_api:dirty_all_read(?DB_ROLE_BASE, RoleId) of
                [RoleBase] ->
                    #p_role_base{gold=OldGold,silver=OldSilver,coin=OldCoin} = RoleBase, 
                    NewRoleBase = RoleBase#p_role_base{gold = OldGold + Gold,
                                                       silver = OldSilver + Silver,
                                                       coin = OldCoin + Coin},
                    db_api:dirty_all_write(?DB_ROLE_BASE, NewRoleBase),
                    %% 日志
                    LogTime = common_tool:now(),
                    case Gold > 0 of
                        true ->
                            common_log:log_gold({NewRoleBase,?LOG_GAIN_GOLD_ADMIN_PAY,LogTime,Gold});
                        _ ->
                            next
                    end,
                    case Silver > 0 of
                        true ->
                            common_log:log_silver({NewRoleBase,?LOG_GAIN_SILVER_ADMIN_PAY,LogTime,Silver});
                        _ ->
                            next
                    end,
                    case Coin > 0 of
                        true ->
                            common_log:log_coin({NewRoleBase,?LOG_GAIN_COIN_ADMIN_PAY,LogTime,Coin});
                        _ ->
                            next
                    end,
                    ok;
                _ ->
                    ?ERROR_MSG("~ts,RoleId=~w,Gold=~w,Silver=~w,Coin=~w,Error=not_found_role_base",[?_LANG_LOCAL_002,RoleId,Gold,Silver,Coin])
                 
            end;
        _ ->
            ok
    end.
%% @doc 检察是否可以接收系统信件
if_can_accept_system_letter(RoleId, Now) ->
    %% 超过14天不登陆，不接收系统信件
    case mod_role:get_role_base(RoleId) of
        {ok,#p_role_base{last_login_time = LastLoginTime}} ->
            next;
        _ ->
            case common_misc:get_role_base(RoleId) of
                {ok,#p_role_base{last_login_time = LastLoginTime}} ->
                    next;
                _ ->
                    LastLoginTime = 0
            end
    end,
    case LastLoginTime of
        0 ->
            false;
        _ ->
            Now - LastLoginTime =< 14*24*3600
    end.

%% r_letter_info==> p_letter_simple_info
transfer_to_toc(LetterInfo)->
    #r_letter_info{id=LetterId,
                   title=Title,
                   role_name=RoleName,
                   send_time=SendTime,
                   type=LetterType,
                   state=State,
                   goods_list=GoodsList,
                   is_send=IsSend}=LetterInfo,
    #p_letter_simple_info{id   = LetterId,
                          sender = RoleName,
                          receiver = RoleName,
                          title    = Title,       
                          send_time  = SendTime,   
                          type       = LetterType,     
                          state      = State,   
                          is_have_goods = erlang:length(GoodsList)>0,
                          is_send = IsSend}.


-define(role_letter_counter,role_letter_counter).
get_role_letter_counter(RoleId)->
    case erlang:get({?role_letter_counter,RoleId}) of
        undefined->0;
        {Date,Counter}->
            Today = date(),
            case Today =:=Date of
                true->Counter;
                false->0
            end
    end.

add_role_letter_counter(RoleId)->
    case erlang:get({?role_letter_counter,RoleId}) of
        undefined->erlang:put({?role_letter_counter,RoleId},{date(),1});
        {Date,Counter}->
            case Date =:= date() of
                true->
                    erlang:put({?role_letter_counter,RoleId},{Date,Counter+1});
                false->
                    erlang:put({?role_letter_counter,RoleId},{date(),1})
            end
    end.

