-module(inspector).
-compile(export_all).
-define(P , "sites").
-export([readlines/0]).

readlines() ->
    {ok, Device} = file:open(?P, [read]),
    get_all_sites(Device, []).
    
get_all_sites(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line ->
            get_all_sites(Device, Accum ++ string:tokens(Line, "\n"))
        
    end.

check_content(Data, Req) ->
    Patterns = binary:split(list_to_binary(Req), <<" ">>),
    case binary:match(Data, Patterns,[]) of
        {_Pat1,_Pat2} ->
            found;
        nomatch ->
            not_found;
        _->
            not_found
    end.
            
request(Site, Req) ->
    Method = get,
    URL = Site,
    Headers = [],
    ReqBody = <<>>,
    Options = [{follow_redirect, true}, {max_redirect, 5}],
    {ok, S, H, Ref} = hackney:request(Method, URL, Headers, ReqBody, Options),
    {ok, Data} = hackney:body(Ref),
    %%Check for the content requierments 
    Check = check_content(Data, Req),
    %Calcualte the response time, extract response time from server and compare with
    %request timestamp
    {<<"Date">>, Time} = lists:keyfind(<<"Date">>, 1, H),
    {S,Check,Time}.

schedule(Seconds)->
    InspectJob = {{once, Seconds},
        {inspector, resolve_inspection, []}},
    erlcron:cron(InspectJob).

