-module(erl4th).
-export([eval/4]).


%% Done evaluating the input stream
eval([],Stack,Return,Dict) ->
	{ Stack, Return, Dict };

%% Evaluating an instruction stream
eval(Ins,Stack,Return,Dict) ->
	io:format("~p ~p ~p ~n", [ Ins, Stack, Return ]),
	[ Op | Rem ] = Ins,
	case Op of
	%% math
		'+' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Top + Next | Rest ], Return, Dict);
		'-' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Next - Top | Rest ], Return, Dict);
		'*' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Top * Next | Rest ], Return, Dict);
		'/' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Next / Top | Rest ], Return, Dict);
		'%' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Next rem Top | Rest ], Return, Dict);
	%% binary logic
		'&' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Top band Next | Rest ], Return, Dict);
		'|' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Top bor Next | Rest ], Return, Dict);
		'^' -> 
			[ Top, Next | Rest ] = Stack,
			eval(Rem, [ Top bxor Next | Rest ], Return, Dict);
	%% flow control
		';' -> 
			[ Rops | RetRem ] = Return,
			eval(Rops, Stack, RetRem, Dict);
		':' -> 
			[ Term | DefRem ] = Rem,
			Dict2 = [ { Term, DefRem } | Dict ],
			eval([], Stack, Return, Dict2);
		X when is_atom(X) -> 
			{ X, NewOps } = proplists:lookup(X,Dict),
			eval( NewOps, Stack, [ Rem | Return ], Dict );
	%% literals
		X when is_integer(X) -> 
			eval(Rem, [ X | Stack ], Return, Dict);
		%% convert to integer for now
		X when is_float(X) ->
			eval([ round(X) | Rem ], Stack, Return, Dict );
		%% convert to atom for now
		X when is_binary(X) ->
			eval([ list_to_atom(binary:bin_to_list(X)) | Rem], Stack, Return, Dict );
		%% convert to atom for now
		X when is_list(X) ->
			eval([ list_to_atom(X) | Rem], Stack, Return, Dict );	
		X when is_tuple(X) ->
			io:format("Invalid term ~p ~n", [ X ]);
	%% bad input stream catcher
		X ->
			io:format("Unknown op ~p ~n", [ X ])
	end.
	
