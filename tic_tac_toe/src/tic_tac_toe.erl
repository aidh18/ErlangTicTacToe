-module(tic_tac_toe).

-export([start_game/0,play/1,loop_game/2,place_symbol/3,create_board/0]).

start_game()->
    Board = create_board(),
    Game_id = spawn(?MODULE, loop_game, [Board,x]),
    register(game,Game_id),
    started.

play(Position)->
	game ! {self(),Position},
	receive
         Response ->
             Response
     end.

loop_game(Board,Player)->
    receive
        {Pid,Position} when (Position > 0) and (Position < 10)->
            Board = place_symbol(Board, Position, Player),
            Pid ! Board,
            if 
                Player =:= x-> loop_game(Board,o);
                true-> loop_game(Board,x)
            end;
        {Pid,Incorrect}->
            Pid ! {invalid_position, Incorrect},
            loop_game(Board,Player)
    end.
    
create_board()->
    Row1 = {1,2,3},
    Row2 = {4,5,6},
    Row3 = {7,8,9},
    {Row1,Row2,Row3}.

place_symbol({Top,Middle,Bottom},Position,Player) when Position =< 3->
    switch(Top,Position);
place_symbol({Top,Middle,Bottom},Position,Player) when Position =< 6->
    switch(Middle,Position - 3);
place_symbol({Top,Middle,Bottom},Position,Player) when Position =< 6->
    switch(Bottom,Position - 6).

switch({},Position)->
    case
        