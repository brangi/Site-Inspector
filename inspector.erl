-module(inspector).
-compile(export_all).
-define(P , "sites").


do_it()->
    {ok, Device} = file:open(?P, [read]),
    for_each_line(Device).

for_each_line(Device) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device);
        Line ->
            Line
    end.
