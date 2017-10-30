-module(user_management).
-export([start/0, create_account/3, login/3, logout/3, online/0, leftPress/3, rightPress/3, upPress/3, leftReleased/3, rightReleased/3, upReleased/3, info/3]).
%start com 0 parametros, create_account com 2 parametros

start() ->
	Pid = spawn(fun() -> loop(#{}) end),
	register(?MODULE, Pid).
	%map começa vazio no ciclo

create_account(Socket,Username,Passwd) -> 
	?MODULE ! {create_account, Socket, Username, Passwd, self()},
	receive {?MODULE, Res } -> Res end.

	%com nomes registados, envio uma mensagem ao processo que está registado com o nome user_management.
	% envio a operação a realizar, o meu username, passwd e o pid para receber a resposta de verificação vinda do user_management
	% fico a espera de uma resposta que tenha o nome do module e a resposta propriamente dita que vou retornar.
login(Socket,Username,Passwd) -> 
	?MODULE ! {login, Socket, Username, Passwd, self()},
	receive {?MODULE, Res } -> Res end. %valor de retorno que é usado pelo chat.erl

logout(Socket,Username, Passwd) -> 
	?MODULE ! {logout, Socket, Username, Passwd, self()},
	receive {?MODULE, Res } -> Res end.

online() -> 
	?MODULE ! {online, self()},
	receive {?MODULE, Res } -> Res end.

leftPress(Socket, Username, Passwd) -> 
	?MODULE ! {leftPress, Socket, Username, Passwd, self()},
	receive {?MODULE, Res} -> Res end.

rightPress(Socket, Username, Passwd) -> 
	?MODULE ! {rightPress, Socket, Username, Passwd, self()},
	receive {?MODULE, Res} -> Res end.

upPress(Socket, Username, Passwd) -> 
	?MODULE ! {upPress, Socket, Username, Passwd, self()},
	receive {?MODULE, Res} -> Res end.

leftReleased(Socket, Username, Passwd) -> 
	?MODULE ! {leftReleased, Socket, Username, Passwd, self()},
	receive {?MODULE, Res} -> Res end.

rightReleased(Socket, Username, Passwd) -> 
	?MODULE ! {rightReleased, Socket, Username, Passwd, self()},
	receive {?MODULE, Res} -> Res end.

upReleased(Socket, Username, Passwd) -> 
	?MODULE ! {upReleased, Socket, Username, Passwd, self()},
	receive {?MODULE, Res} -> Res end.

info(Socket, Username, Passwd) ->
	?MODULE ! {info, Socket, self()},
	receive {?MODULE, Res} -> Res end.	

loop(M) ->
	receive %está bloqueada (receive) a espera de um pedido de criar conta, ou bloquear, etc. é necessário saber distinguir
		{create_account, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of  %find recebe key,Map e devolve ok,Value ou Error. Vê se o username já está presente
				{ok, _} ->
					io:format("user ja foi criado~n"),
					From ! {?MODULE, user_exists}, %mensagem que o cliente está a espera "user_exists no Res"
					loop(M);
				_ ->
					io:format("user criado~n"),
					From ! {?MODULE, ok},
					%leftBattery, rightBattery, middleBattery, x, y, speed, rot, radShip, mShip, leftBool, rightBool, speedBool
					M1 = maps:put(Username,{Socket,Passwd,false,{100.0,100.0,100.0,500,500,0,0,20,2,false,false,false}},M),
					loop(M1)
			end;  %map com o novo valor (M1), e bloqueia novamente no receive
		{close_account, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket,Passwd, _, _}} -> %caso a chave esteja no map dá ok, e só faz match se o tuplo que for retornado pelo find tiver o valor que vem na mensagem (Password)
					From ! {?MODULE, ok},
					M1 = maps:remove(Username,M),
					loop(M1);
				_ -> %_ ou error
					From ! {?MODULE, invalid},
					loop(M)
				end;
		{login, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {_, Passwd, false, L}} -> % o _ poderia ser True ou False
					From ! {?MODULE, ok},
					M1 = maps:update(Username, {Socket,Passwd,true, L}, M),
					loop(M1);
				_ ->
					io:format("user invalido~n"),
					From ! {?MODULE, invalid},
					loop(M)
				end;
		{logout, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket, Passwd, true, L}} ->
					From ! {?MODULE, ok},
					M1 = maps:update(Username, {Socket,Passwd,false, L}, M),
					loop(M1);
				_ ->
					From ! {?MODULE, invalid},
					loop(M)
			end;
		{leftPress, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket, Passwd, true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, false, Rb, Sb}}} -> 
					io:format("user pressionou inv~p~n", [{Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, false, Rb, Sb}]),
					From ! {?MODULE, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, true, Rb, Sb}},
					M1 = maps:update(Username, {Socket,Passwd,true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, true, Rb, Sb}}, M),
					loop(M1);
				_ -> 
					io:format("leftPress invalido~n"),
					From ! {?MODULE, invalid},
					loop(M)
			end;
		{rightPress, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket, Passwd, true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, false, Sb}}} -> 
					io:format("user pressionou inv~p~n", [{Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, false, Sb}]),
					From ! {?MODULE, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, true, Sb}},
					M1 = maps:update(Username, {Socket,Passwd,true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, true, Sb}}, M),
					loop(M1);
				_ -> 
					io:format("rightPress invalido~n"),
					From ! {?MODULE, invalid},
					loop(M)
			end;
		{upPress, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket, Passwd, true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, Rb, false}}} -> 
					io:format("user pressionou inv~p~n", [{Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, Rb, false}]),
					From ! {?MODULE, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, Rb, true}},
					M1 = maps:update(Username, {Socket,Passwd,true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, Rb, true}}, M),
					loop(M1);
				_ -> 
					io:format("upPress invalido~n"),
					From ! {?MODULE, invalid},
					loop(M)
			end;
		{leftReleased, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket, Passwd, true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, true, Rb, Sb}}} -> 
					%io:format("user pressionou inv~p~n", [{Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, true, Rb, Sb}]),
					From ! {?MODULE, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, false, Rb, Sb}},
					M1 = maps:update(Username, {Socket,Passwd,true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, false, Rb, Sb}}, M),
					loop(M1);
				_ -> 
					io:format("leftReleased invalido~n"),
					From ! {?MODULE, invalid},
					loop(M)
			end;
		{rightReleased, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket, Passwd, true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, true, Sb}}} -> 
					%io:format("user pressionou inv~p~n", [{Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, true, Rb, Sb}]),
					From ! {?MODULE, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, false, Sb}},
					M1 = maps:update(Username, {Socket,Passwd,true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, false, Sb}}, M),
					loop(M1);
				_ -> 
					io:format("rightReleased invalido~n"),
					From ! {?MODULE, invalid},
					loop(M)
			end;
		{upReleased, Socket, Username, Passwd, From} ->
			case maps:find(Username,M) of
				{ok, {Socket, Passwd, true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, Rb, true}}} -> 
					%io:format("user pressionou inv~p~n", [{Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, true, Rb, Sb}]),
					From ! {?MODULE, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, Rb, false}},
					M1 = maps:update(Username, {Socket,Passwd,true, {Lbat, Rbat, Mbat, X, Y, Sp, Rot, RadS, MShip, Lb, Rb, false}}, M),
					loop(M1);
				_ -> 
					io:format("upReleased invalido~n"),
					From ! {?MODULE, invalid},
					loop(M)
			end;
		{info, Socket, From} ->
		 	Online = [{Usern, Bool, Atrib} || {Usern, {_, Pass, Bool, Atrib}} <- maps:to_list(M)],  %lista de compreensao só faz match só se os pares correspondentes ao Username, tenham password true. Não se quer saber qual a Passwd
		 	From ! {?MODULE, Online},
		 	loop(M)
	end.
	