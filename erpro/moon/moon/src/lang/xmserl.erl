%% 
%% @copyright   OvalPo 2013-2013. All Rights Reserved.
%% 
%% @author      ovalpo(yjbgwxf@gmail.com)
%% 
%% @doc         Functions to generate microsoft office XML file
%% 

-module(xmserl).
-export([generate/2]).
-export([expand_content/1]).

-include_lib("xmerl/include/xmerl.hrl").

%% the xml prog
-define(PROLOG, ["<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<?mso-application progid=\"Excel.Sheet\"?>\n"]).
%% the namespace nodes of ms xml
-define(MSXMLNAMESPACENODES, [
        {"o",'urn:schemas-microsoft-com:office:office'},
        {"x",'urn:schemas-microsoft-com:office:excel'},
        {"ss",'urn:schemas-microsoft-com:office:spreadsheet'},
        {"html",'http://www.w3.org/TR/REC-html40'}
    ]).
%% the namespace of ms xml
-define(MSXMLNAMESPACESS, #xmlNamespace{default = 'urn:schemas-microsoft-com:office:spreadsheet', nodes = ?MSXMLNAMESPACENODES}).
-define(MSXMLNAMESPACEO, #xmlNamespace{default = 'urn:schemas-microsoft-com:office:office', nodes = ?MSXMLNAMESPACENODES}).
-define(MSXMLNAMESPACEX, #xmlNamespace{default = 'urn:schemas-microsoft-com:office:excel', nodes = ?MSXMLNAMESPACENODES}).
%% the root element of ms xml
-define(MSXMLROOTELEMENTNAME,'Workbook').
%% the root element attributes of ms xml
-define(MSXMLROOTELEMENTATTRIBUTES, [
        #xmlAttribute{name = xmlns, value = "urn:schemas-microsoft-com:office:spreadsheet", normalized = false},
        #xmlAttribute{name = 'xmlns:o', nsinfo = {"xmlns","o"}, value = "urn:schemas-microsoft-com:office:office", normalized = false},
        #xmlAttribute{name = 'xmlns:x', nsinfo = {"xmlns","x"}, value = "urn:schemas-microsoft-com:office:excel", normalized = false},
        #xmlAttribute{name = 'xmlns:ss', nsinfo = {"xmlns","ss"}, value = "urn:schemas-microsoft-com:office:spreadsheet", normalized = false},
        #xmlAttribute{name = 'xmlns:html', nsinfo = {"xmlns","html"}, value = "http://www.w3.org/TR/REC-html40", normalized = false}
    ]).

%% the root element
-define(MSXMLROOTELEMENT,
    #xmlElement{
        name = ?MSXMLROOTELEMENTNAME,
        expanded_name = ?MSXMLROOTELEMENTNAME,
        namespace = ?MSXMLNAMESPACESS,
        attributes = ?MSXMLROOTELEMENTATTRIBUTES
    }).

%% @spec generate(File, DataList) -> ok | {error, Reason}
%% DataList = [RowDataList | ..]
%% Rowdatalist = [ColumnData | ..]
%% Columndata = IOlist
%% @doc generate an ms xml file with the content DataList
generate(File, Data) ->
    NewData = lists:reverse([lists:reverse(E) || E <- Data]),
    Content = expand_content(NewData),
    Export = xmerl:export([Content], xmerl_xml, [{prolog, ?PROLOG}]),
    case file:open(File, [write]) of
        {ok, IoDev} ->
            io:format(IoDev, "~s~n",[lists:flatten(Export)]),
            file:close(IoDev),
            ok;
        {error, Reason} ->
            {error, Reason}
    end.

%% expand the xml file content
expand_content(Data) ->
    Root = ?MSXMLROOTELEMENT,
    Content = expand_root_content(Data),
    Root#xmlElement{content = Content}.

%% expand the root element content
expand_root_content(Data) ->
    [
        expandNewLine(1),
        expandDocumentProperties(),
        expandNewLine(1),
        expandOfficeDocumentSettings(),
        expandNewLine(1),
        expandExcelWorkbook(),
        expandNewLine(1),
        expandStyles(),
        expandNewLine(1),
        expandSheet(Data),
        expandNewLine(1)
    ].

%% expand a newline
expandNewLine(Lev) ->
    #xmlText{value = expandNewLine(Lev, [])}.

expandNewLine(Lev, List) when Lev =< 0 ->
    [$\n | List];
expandNewLine(Lev, List) ->
    expandNewLine(Lev - 1, [$ | List]).

expandDocumentProperties() ->
    {{Y,M,D},{H, MM, S}} = {date(),time()},
    Now = lists:flatten(io_lib:format("~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ",[Y,M,D,H,MM,S])),
    #xmlElement{
        name = 'DocumentProperties',
        expanded_name = 'DocumentProperties',
        namespace = ?MSXMLNAMESPACEO,
        attributes = [#xmlAttribute{name = xmlns, value = "urn:schemas-microsoft-com:office:office"}],
        content = [
            expandNewLine(2),
            #xmlElement{name = 'Created',expanded_name = 'Created', namespace = ?MSXMLNAMESPACEO, content = [#xmlText{value = Now}]},
            expandNewLine(2),
            #xmlElement{name = 'LastSaved',expanded_name = 'LastSaved', namespace = ?MSXMLNAMESPACEO, content = [#xmlText{value = Now}]},
            expandNewLine(2),
            #xmlElement{name = 'Version',expanded_name = 'Version', namespace = ?MSXMLNAMESPACEO, content = [#xmlText{value = "1.00"}]},
            expandNewLine(2)
        ]
    }.

expandOfficeDocumentSettings() ->
    #xmlElement{
        name = 'OfficeDocumentSettings',
        expanded_name = 'OfficeDocumentSettings',
        namespace = ?MSXMLNAMESPACEO,
        attributes = [#xmlAttribute{name = xmlns, value = "urn:schemas-microsoft-com:office:office"}],
        content = [
            expandNewLine(2),
            #xmlElement{name = 'AllowPNG',expanded_name = 'AllowPNG', namespace = ?MSXMLNAMESPACEO},
            expandNewLine(2),
            #xmlElement{name = 'RemovePersonalInformation',expanded_name = 'RemovePersonalInformation', namespace = ?MSXMLNAMESPACEO},
            expandNewLine(2)
        ]
    }.

expandExcelWorkbook() ->
    #xmlElement{
        name = 'ExcelWorkbook',
        expanded_name = 'ExcelWorkbook',
        namespace = ?MSXMLNAMESPACEX,
        attributes = [#xmlAttribute{name = xmlns, value = "urn:schemas-microsoft-com:office:excel"}],
        content = [
            expandNewLine(2),
            #xmlElement{name = 'WindowHeight', expanded_name = 'WindowHeight', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "8000"}]},
            expandNewLine(2),
            #xmlElement{name = 'WindowWidth', expanded_name = 'WindowWidth', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "14800"}]},
            expandNewLine(2),
            #xmlElement{name = 'WindowTopX', expanded_name = 'WindowTopX', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "200"}]},
            expandNewLine(2),
            #xmlElement{name = 'WindowTopY', expanded_name = 'WindowTopY', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "200"}]},
            expandNewLine(2),
            #xmlElement{name = 'ProtectStructure', expanded_name = 'ProtectStructure', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "False"}]},
            expandNewLine(2),
            #xmlElement{name = 'ProtectWindows', expanded_name = 'ProtectWindows', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "False"}]},
            expandNewLine(2)
        ]
    }.

expandStyles() ->
    #xmlElement{
        name = 'Styles',
        expanded_name = 'Styles',
        namespace = ?MSXMLNAMESPACESS,
        content = [
            expandNewLine(2),
            expandStylesDefault(),
            expandNewLine(2),
            expandStylesOne(),
            expandNewLine(2)
        ]
    }.

expandStylesDefault() ->
    #xmlElement{
        name = 'Style',
        expanded_name = 'Style', 
        namespace = ?MSXMLNAMESPACESS,
        attributes = [
            #xmlAttribute{name = 'ss:ID', nsinfo = {"ss","ID"}, value = "Default",normalized = false},
            #xmlAttribute{name = 'ss:Name', nsinfo = {"ss","Name"}, value = "Normal",normalized = false}],
        content = [
            expandNewLine(3),
            #xmlElement{name = 'Alignment',expanded_name = 'Alignment', namespace = ?MSXMLNAMESPACESS,
                attributes = [#xmlAttribute{name = 'ss:Vertical', nsinfo = {"ss","Vertical"}, value = "Bottom",normalized = false}]},
            expandNewLine(3),
            #xmlElement{name = 'Borders',expanded_name = 'Borders', namespace = ?MSXMLNAMESPACESS},
            expandNewLine(3),
            #xmlElement{name = 'Font',expanded_name = 'Font', namespace = ?MSXMLNAMESPACESS,
                attributes = 
                [#xmlAttribute{name = 'ss:FontName', nsinfo = {"ss","FontName"}, value = "Arial", normalized = false},
                    #xmlAttribute{name = 'x:CharSet', nsinfo = {"x","CharSet"}, value = "134",normalized = false},
                    #xmlAttribute{name = 'ss:Size', nsinfo = {"ss","Size"}, value = "11",normalized = false},
                    #xmlAttribute{name = 'ss:Color', nsinfo = {"ss","Color"}, value = "#000000",normalized = false}]},
            expandNewLine(3),
            #xmlElement{name = 'Interior',expanded_name = 'Interior', namespace = ?MSXMLNAMESPACESS},
            expandNewLine(3),
            #xmlElement{name = 'NumberFormat',expanded_name = 'NumberFormat', namespace = ?MSXMLNAMESPACESS},
            expandNewLine(3),
            #xmlElement{name = 'Protection',expanded_name = 'Protection', namespace = ?MSXMLNAMESPACESS},
            expandNewLine(3)
        ]
    }.

expandStylesOne() ->
    #xmlElement{
        name = 'Style',
        expanded_name = 'Style', 
        namespace = ?MSXMLNAMESPACESS,
        attributes = [#xmlAttribute{name = 'ss:ID', nsinfo = {"ss","ID"}, value = "sovalpo",normalized = false}],
        content = [
            expandNewLine(3),
            #xmlElement{name = 'Alignment',expanded_name = 'Alignment', namespace = ?MSXMLNAMESPACESS,
                attributes = [
                    #xmlAttribute{name = 'ss:Horizontal', nsinfo = {"ss","Horizontal"}, value = "Left",normalized = false},
                    #xmlAttribute{name = 'ss:Vertical', nsinfo = {"ss","Vertical"}, value = "Bottom",normalized = false}
                ]},
            expandNewLine(3)
        ]
    }.

expandSheet(Data) ->
    #xmlElement{
        name = 'Worksheet',
        expanded_name = 'Worksheet', 
        namespace = ?MSXMLNAMESPACESS,
        attributes = [#xmlAttribute{name = 'ss:Name', nsinfo = {"ss","Name"}, value = "xml_create_by_xmserl",normalized = false}],
        content = [
            expandNewLine(2),
            expandSheetTable(Data),
            expandNewLine(2),
            expandWorksheetOptions(),
            expandNewLine(2)
        ]
    }.

expandSheetTable(Data) ->
    ContentData = expandSheetTableRows(Data),
    RowCount = length(Data),
    ColumnCount = lists:max([length(E) || E <- Data]),
    #xmlElement{
        name = 'Table',
        expanded_name = 'Table', 
        namespace = ?MSXMLNAMESPACESS,
        attributes = [
            #xmlAttribute{name = 'ss:ExpandedColumnCount', nsinfo = {"ss","ExpandedColumnCount"}, value = integer_to_list(ColumnCount),normalized = false},
            #xmlAttribute{name = 'ss:ExpandedRowCount', nsinfo = {"ss","ExpandedRowCount"}, value = integer_to_list(RowCount),normalized = false},
            #xmlAttribute{name = 'x:FullColumns', nsinfo = {"x","FullColumns"}, value = "1",normalized = false},
            #xmlAttribute{name = 'x:FullRows', nsinfo = {"x","FullRows"}, value = "1",normalized = false},
            #xmlAttribute{name = 'ss:DefaultColumnWidth', nsinfo = {"ss","DefaultColumnWidth"}, value = "54",normalized = false},
            #xmlAttribute{name = 'ss:DefaultRowHeight', nsinfo = {"ss","DefaultRowHeight"}, value = "13.5",normalized = false}
        ],
        content = expandSheetColumnSetting(ColumnCount) ++ ContentData
    }.

%% control the column width, you can use the name ss:Index to control the specify column width
expandSheetColumnSetting(Num) ->
    expandSheetColumnSetting(Num, [expandNewLine(3)]).
expandSheetColumnSetting(Num, Acc) when Num < 1 ->
    [expandNewLine(3) | Acc];
expandSheetColumnSetting(Num, Acc) ->
    Elem = #xmlElement{name = 'Column',expanded_name = 'Column', namespace = ?MSXMLNAMESPACESS,
        attributes = [
%%            #xmlAttribute{name = 'ss:Index', nsinfo = {"ss","Index"},value = Num, normalized = false},
            #xmlAttribute{name = 'ss:AutoFitWidth', nsinfo = {"ss","AutoFitWidth"}, value = "0",normalized = false},
            #xmlAttribute{name = 'ss:Width', nsinfo = {"ss","Width"}, value = "100",normalized = false}
        ]
    },
    expandSheetColumnSetting(Num - 1, [Elem | Acc]).

%% expand data
expandSheetTableRows(Data) ->
    expandSheetTableRows(Data, []).
expandSheetTableRows([], Contents) ->
    Contents;
expandSheetTableRows([H | T], Contents) ->
    expandSheetTableRows(T, [expandSheetTableRow(H), expandNewLine(3)| Contents]).

expandSheetTableRow(H) ->
    RowContent = expandSheetTabelRowElems(H),
    #xmlElement{name = 'Row',expanded_name = 'Row', namespace = ?MSXMLNAMESPACESS,
        attributes = [#xmlAttribute{name = 'ss:AutoFitHeight', nsinfo = {"ss","AutoFitHeight"}, value = "0",normalized = false}],
        content = [expandNewLine(4) | RowContent]
    }.

%% expand each row's elems
expandSheetTabelRowElems(H) ->
    expandSheetTabelRowElems(H, []).
expandSheetTabelRowElems([], Elems) ->
    Elems;
expandSheetTabelRowElems([H | T], Elems) ->
    expandSheetTabelRowElems(T, [expandSheetTabelRowElem(H), expandNewLine(4)| Elems]).

expandSheetTabelRowElem(H) ->
    #xmlElement{
        name = 'Cell',expanded_name = 'Cell', namespace = ?MSXMLNAMESPACESS,
        attributes = [#xmlAttribute{name = 'ss:StyleID', nsinfo = {"ss","StyleID"}, value = "sovalpo",normalized = false}],
        content = [#xmlElement{name = 'Data',expanded_name = 'Data', namespace = ?MSXMLNAMESPACESS, content = [#xmlText{value = H}],
                attributes = [#xmlAttribute{name = 'ss:Type', nsinfo = {"ss","Type"}, value = "String",normalized = false}]}]
    }.

expandWorksheetOptions() ->
    #xmlElement{
        name = 'WorksheetOptions', expanded_name = 'WorksheetOptions',
        namespace = ?MSXMLNAMESPACEX,
        attributes = [#xmlAttribute{name = xmlns, value = "urn:schemas-microsoft-com:office:excel", normalized = false}],
        content = [
            expandNewLine(3),
            expandPageSetup(),
            expandNewLine(3),
            #xmlElement{name = 'Unsynced',expanded_name = 'Unsynced', namespace = ?MSXMLNAMESPACEX},
            expandNewLine(3),
            expandPrint(),
            expandNewLine(3),
            #xmlElement{name = 'Selected',expanded_name = 'Selected', namespace = ?MSXMLNAMESPACEX},
            expandNewLine(3),
            #xmlElement{name = 'ProtectObjects',expanded_name = 'ProtectObjects', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "False"}]},
            expandNewLine(3),
            #xmlElement{name = 'ProtectScenarios',expanded_name = 'ProtectScenarios', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "False"}]},
            expandNewLine(3)
        ]
    }.

expandPageSetup() ->
    #xmlElement{
        name = 'PageSetup',expanded_name = 'PageSetup',
        namespace = ?MSXMLNAMESPACEX,
        content = [
            expandNewLine(3),
            #xmlElement{name = 'Header',expanded_name = 'Header', namespace = ?MSXMLNAMESPACEX,
                attributes = [#xmlAttribute{name = 'x:Margin', nsinfo = {"x","Margin"}, value = "0.3",normalized = false}]},
            expandNewLine(3),
            #xmlElement{name = 'Footer',expanded_name = 'Footer', namespace = ?MSXMLNAMESPACEX,
                attributes = [#xmlAttribute{name = 'x:Margin', nsinfo = {"x","Margin"}, value = "0.3",normalized = false}]},
            expandNewLine(3),
            #xmlElement{name = 'PageMargins',expanded_name = 'PageMargins', namespace = ?MSXMLNAMESPACEX,
                attributes = [
                    #xmlAttribute{name = 'x:Bottom', nsinfo = {"x","Bottom"}, value = "0.75",normalized = false},
                    #xmlAttribute{name = 'x:Left', nsinfo = {"x","Left"}, value = "0.7",normalized = false},
                    #xmlAttribute{name = 'x:Right', nsinfo = {"x","Right"}, value = "0.7",normalized = false},
                    #xmlAttribute{name = 'x:Top', nsinfo = {"x","Top"}, value = "0.75",normalized = false}
                ]},
            expandNewLine(3)
        ]
    }.

expandPrint() ->
    #xmlElement{
        name = 'Print',expanded_name = 'Print',
        namespace = ?MSXMLNAMESPACEX,
        content = [
            expandNewLine(4),
            #xmlElement{name = 'ValidPrinterInfo', expanded_name = 'ValidPrinterInfo', namespace = ?MSXMLNAMESPACEX},
            expandNewLine(4),
            #xmlElement{name = 'HorizontalResolution', expanded_name = 'HorizontalResolution', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "600"}]},
            expandNewLine(4),
            #xmlElement{name = 'VerticalResolution', expanded_name = 'VerticalResolution', namespace = ?MSXMLNAMESPACEX, content = [#xmlText{value = "600"}]},
            expandNewLine(4)
        ]
    }.
