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





