-module(inspector_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    application:start(crypto),
    application:start(public_key),
    application:start(ssl),
    application:start(hackney),
    hackney:start(),
    inspector_sup:start_link().

stop(_State) ->
    ok.
