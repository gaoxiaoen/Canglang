%% @author zj
%% @doc game_http tools


-module(http_tool).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

%%返回XML数据 【不】自动加上xml头
return_xml({no_auto_head, XmlResult}, Req) ->
    Req:ok({"text/xml; charset=utf-8", [{"Server","MCCQ"}],XmlResult});
%%返回XML数据 自动加上xml头
return_xml({auto_head, XmlResult}, Req) ->
    XmlResult2 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"++XmlResult,
    Req:ok({"text/xml; charset=utf-8", [{"Server","MCCQ"}], XmlResult2}).
    
return_string(StringResult, Req) ->
    Req:ok({"text/html; charset=utf-8", [{"Server","MCCQ"}],StringResult}).
return_json(List, Req) ->
    Result =(catch(json_tool:to_json(List))),
    Req:ok({"text/html; charset=utf-8", [{"Server","MCCQ"}],Result}).

return_json_ok(Req) ->
    List = [{result, ok}],
    return_json(List, Req).

return_json_error(Req) ->
    List = [{result, error}],
    return_json(List, Req).
    

process_not_run(Req) ->
    List = [{result, error}],
    return_json(List, Req).

now_nanosecond() ->
    {A, B, C} = erlang:now(),
    A * 1000000000000 + B*1000000 + C.

%%@doc 获取QueryString中的Int参数值
get_int_param(Key,QueryString)->
    Val = proplists:get_value(Key,QueryString),
    util:to_integer(Val).

%%@doc 获取QueryString中的atom参数值
get_atom_param(Key,QueryString)->
    Val = proplists:get_value(Key,QueryString),
    util:to_atom(Val).

%%@doc 获取QueryString中的string参数值
get_string_param(Key,QueryString)->
    proplists:get_value(Key, QueryString).

%% @doc 将Record转换为json
transfer_to_json(Rec)->
    RecName = erlang:element(1, Rec),
    transfer_to_json(RecName,Rec).

-define(TRANSFER_TO_JSON2(RecName,Rec),
        transfer_to_json(RecName,Rec)->
            FieldVals = get_record_values(Rec),
            do_list_match( record_info(fields,RecName),FieldVals,[])
        ).

transfer_to_json(RecName,_Rec) ->
    {error,record_not_defined,RecName}.
   

date_to_string(DateTime)->
    {{Y,M,D},{HH,MM,SS}} = DateTime,
    lists:flatten( io_lib:format("~w-~w-~w ~w:~w:~w",[Y,M,D,HH,MM,SS]) ).

time_to_string(Time)->
    {HH,MM,SS} = Time,
    lists:flatten( io_lib:format("~w:~w:~w",[HH,MM,SS]) ).

%% @doc 对列表的值进行新的配对
do_list_match([],[],Result)->
    lists:reverse(Result);
do_list_match([HName|NameList],[HVal|ValList],Result)->
    Rec = case is_tuple(HVal) of
              true->
                  case HVal of
                      {{Y,M,D},{HH,_MM,_SS}} when is_integer(Y) andalso is_integer(M) 
                                                      andalso is_integer(D) andalso is_integer(HH) ->
                          {HName,date_to_string(HVal)};
                      {HH,MM,SS}when is_integer(HH) andalso is_integer(MM)andalso is_integer(SS)   ->
                          {HName,time_to_string(HVal)};
                      _ ->
                          {HName,transfer_to_json(HVal)}
                  end;
              false-> 
                  case is_list(HVal) andalso length(HVal)>0 of
                      true->
                          do_list_match_2(HName,HVal);
                      false->
                          case HVal of
                              undefined->{HName,""};
                              []-> {HName,""};
                              _ -> {HName,HVal}
                          end
                  end
          end,
    do_list_match(NameList,ValList,[Rec|Result]).

do_list_match_2(HName,HVal)->
    case is_tuple( hd(HVal) ) of
        true->
            SubRecList = [ transfer_to_json(SubRec)||SubRec<- HVal ],
            {HName,SubRecList};
        false->
            case HVal of
                undefined->{HName,""};
                _ -> {HName,HVal}
            end
    end.

%% @doc 获取Record的所有值的列表
get_record_values(Record)->
    [_H | Values] = tuple_to_list(Record),
    Values.

%% ====================================================================
%% Internal functions
%% ====================================================================


