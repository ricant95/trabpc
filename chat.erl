-module(chat).
-export([server/1]).

server(Port) ->
	Room = spawn(fun() -> room([]) end),
	user_management:start(),
	{ok, LSock} = gen_tcp:listen(Port, [list, {packet, line}, {reuseaddr, true}]),
	acceptor(LSock, Room).

acceptor(LSock, Room) ->
	{ok, Sock} = gen_tcp:accept(LSock),
	spawn(fun() -> acceptor(LSock, Room) end),
	Room ! {enter, self()},
	user(Sock, Room).

room(Pids) ->
	receive
		{enter, Pid} ->
			io:format("user entered~n", []),
			room([Pid | Pids]);
		{line, Data} = Msg ->
			io:format("received ~p~n", [Data]),
			[Pid ! Msg || Pid <- Pids], %envia mensagem ao pid, que depois é recebido no {line, Data}
			room(Pids);
		{leave, Pid} ->
			io:format("user left~n", []),
			room(Pids -- [Pid])
		end.

user(Sock, Room) ->
	receive
		{line, Data} ->
			io:format("2user message~n", []),
			gen_tcp:send(Sock, Data),
			user(Sock, Room);
		{tcp, Socket, Data} ->
			L=string:tokens(Data," "),
			L=string:strip(L,both,$\n),
			L=string:strip(L,both,$\n),
			case L of
				["login", Username, Passwd] -> io:format("user logined~p~n", [Username]),
						   					   case user_management:login(Socket, Username, Passwd) of
						   					   		ok -> gen_tcp:send(Sock, "ok ");	%o valor de retorno é em atom, que não dá para enviar pelo socket -> enviar em string
						   					   		_ -> gen_tcp:send(Sock, "invalid ")
						   					   	end;
						   					   	%gen_tcp:send(Sock, Data);
						   					   	%user(Sock, Room);
				["create_account", Username, Passwd] -> io:format("user create_account~p~n", [L]),
						   					   case user_management:create_account(Socket, Username, Passwd) of
						   					   		user_exists -> gen_tcp:send(Sock, "user_exists ");
						   					   		_ -> gen_tcp:send(Sock, "ok ")
						   					   	end;
				%ainda por fazer
				["logout", Username, Passwd] -> io:format("user logout~p~n", [L]),
						   					   user_management:logout(Socket, Username, Passwd);
				["close_account", Username, _] -> io:format("user logout~p~n", [L]),
						   					   user_management:close_account(Socket, Username);
				["leftPress", Username, Passwd] -> %io:format("user pressed~p~n", [L]),
												   %user_management:leftPress(Socket, Username, Passwd);
													B = [ <<" ">> ],
													C = <<",">>,
													Lista = tuple_to_list(user_management:leftPress(Socket, Username, Passwd)),
													M = lists:merge([integer_to_list(O) || O <- Lista, is_integer(O)], [atom_to_list(N) || N <- Lista, is_atom(N)]),
													N = lists:merge([float_to_list(O, [{decimals,2}]) || O <- Lista, is_float(O)], M),
													%io:format("lista~p~n",[N]); % já é uma lista de strings
													ListaBin = [ list_to_binary(P) || P <- N],
													ListaBin3 = [ << Q/binary, C/binary>> || Q <- ListaBin ],
													ListaBin2 = lists:append(ListaBin3,B),
													io:format("lista~p~n",[ListaBin2]),
													gen_tcp:send(Sock, ListaBin2);
				["leftReleased", Username, Passwd] -> %io:format("user released~p~n", [[  || M <- (tuple_to_list(user_management:leftReleased(Socket, Username, Passwd)))]]);
													B = [ <<" ">> ],
													C = <<",">>,
													Lista = tuple_to_list(user_management:leftReleased(Socket, Username, Passwd)),
													M = lists:merge([integer_to_list(O) || O <- Lista, is_integer(O)], [atom_to_list(N) || N <- Lista, is_atom(N)]),
													N = lists:merge([float_to_list(O, [{decimals,2}]) || O <- Lista, is_float(O)], M),
													%io:format("lista~p~n",[N]); % já é uma lista de strings
													ListaBin = [ list_to_binary(P) || P <- N],
													ListaBin3 = [ << Q/binary, C/binary>> || Q <- ListaBin ],
													ListaBin2 = lists:append(ListaBin3,B),
													io:format("lista~p~n",[ListaBin2]),
													gen_tcp:send(Sock, ListaBin2);
													%fazer list_to_binary para enviar as cenas para o java ? 
													% case user_management:leftReleased(Socket, Username, Passwd) of
							   					   	%	ok -> gen_tcp:send(Sock, "ok ");
							   					   	%	_ -> gen_tcp:send(Sock, "invalid ")
							   					   	%end;
				["rightPress", Username, Passwd] -> %io:format("user pressed~p~n", [L]),
													%user_management:rightPress(Socket, Username, Passwd);
													B = [ <<" ">> ],
													C = <<",">>,
													Lista = tuple_to_list(user_management:rightPress(Socket, Username, Passwd)),
													M = lists:merge([integer_to_list(O) || O <- Lista, is_integer(O)], [atom_to_list(N) || N <- Lista, is_atom(N)]),
													N = lists:merge([float_to_list(O, [{decimals,2}]) || O <- Lista, is_float(O)], M),
													%io:format("lista~p~n",[N]); % já é uma lista de strings
													ListaBin = [ list_to_binary(P) || P <- N],
													ListaBin3 = [ << Q/binary, C/binary>> || Q <- ListaBin ],
													ListaBin2 = lists:append(ListaBin3,B),
													io:format("lista~p~n",[ListaBin2]),
													gen_tcp:send(Sock, ListaBin2);
				["upPress", Username, Passwd] -> %io:format("user pressed~p~n", [L]),
													%user_management:upPress(Socket, Username, Passwd);
													B = [ <<" ">> ],
													C = <<",">>,
													Lista = tuple_to_list(user_management:upPress(Socket, Username, Passwd)),
													M = lists:merge([integer_to_list(O) || O <- Lista, is_integer(O)], [atom_to_list(N) || N <- Lista, is_atom(N)]),
													N = lists:merge([float_to_list(O, [{decimals,2}]) || O <- Lista, is_float(O)], M),
													%io:format("lista~p~n",[N]); % já é uma lista de strings
													ListaBin = [ list_to_binary(P) || P <- N],
													ListaBin3 = [ << Q/binary, C/binary>> || Q <- ListaBin ],
													ListaBin2 = lists:append(ListaBin3,B),
													io:format("lista~p~n",[ListaBin2]),
													gen_tcp:send(Sock, ListaBin2);
				["rightReleased", Username, Passwd] -> %io:format("user released~p~n", [L]);
													B = [ <<" ">> ],
													C = <<",">>,
													Lista = tuple_to_list(user_management:rightReleased(Socket, Username, Passwd)),
													M = lists:merge([integer_to_list(O) || O <- Lista, is_integer(O)], [atom_to_list(N) || N <- Lista, is_atom(N)]),
													N = lists:merge([float_to_list(O, [{decimals,2}]) || O <- Lista, is_float(O)], M),
													%io:format("lista~p~n",[N]); % já é uma lista de strings
													ListaBin = [ list_to_binary(P) || P <- N],
													ListaBin3 = [ << Q/binary, C/binary>> || Q <- ListaBin ],
													ListaBin2 = lists:append(ListaBin3,B),
													io:format("lista~p~n",[ListaBin2]),
													gen_tcp:send(Sock, ListaBin2);
													%fazer list_to_binary para enviar
				["upReleased", Username, Passwd] -> %io:format("user released~p~n", [L]);
													B = [ <<" ">> ],
													C = <<",">>,
													Lista = tuple_to_list(user_management:upReleased(Socket, Username, Passwd)),
													M = lists:merge([integer_to_list(O) || O <- Lista, is_integer(O)], [atom_to_list(N) || N <- Lista, is_atom(N)]),
													N = lists:merge([float_to_list(O, [{decimals,2}]) || O <- Lista, is_float(O)], M),
													%io:format("lista~p~n",[N]); % já é uma lista de strings
													ListaBin = [ list_to_binary(P) || P <- N],
													ListaBin3 = [ << Q/binary, C/binary>> || Q <- ListaBin ],
													ListaBin2 = lists:append(ListaBin3,B),
													io:format("lista~p~n",[ListaBin2]),
													gen_tcp:send(Sock, ListaBin2);
													%fazer list_to_binary para enviar	
				["info", Username, Passwd] -> io:format("A pedir info~n", []),
											  V = <<",">>,
											  E = <<" ">>,
											  Barr = <<";">>,
											  Bn = <<"\n">>,
											  Lista = user_management:info(Socket, Username, Passwd),
											  ListaBin = [{A, B, tuple_to_list(D)} || {A, B, D} <- Lista],
											  ListaBin2 = [{A, B, lists:merge3([integer_to_list(O) || O <- D, is_integer(O)], [atom_to_list(N) || N <- D, is_atom(N)], [float_to_list(O, [{decimals,2}]) || O <- D, is_float(O)])} || {A, B, D} <- ListaBin],
											  ListaBin3 = [{list_to_binary(A), list_to_binary(atom_to_list(B)), [list_to_binary(N) || N <- D]} || {A, B, D} <- ListaBin2],
											  ListaBin4 = [[<<A/binary, V/binary>>, <<B/binary, E/binary>>, [ << Q/binary, V/binary>> || Q <- D ], Barr] || {A, B, D} <- ListaBin3],
											  %ListaBin5 = lists:append(ListaBin4,Bn),
											  io:format("lista aqui~p~n",[ListaBin4]),
											  gen_tcp:send(Sock, ListaBin4);
											  %gen_tcp:send(Sock, Bn);	
				_ -> io:format("I don't know what you want from me :(~n", [])
			end,
			Room ! {line, Data},
			io:format("3user message~n", []),
			user(Sock, Room);
		{tcp_closed, _} ->
			Room ! {leave, self()};
		{tcp_error, _, _} ->
			Room ! {leave, self()}
	end.
