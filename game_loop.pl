:- use_module('./util/auxiliary_functions').

len_dealers_card([_]).
all_cards_are_valid(X) :- subset(X, ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']).
min_len_user_cards(X) :-
    length(X, TAM),
    TAM > 1.

filter_cards_above_interupt(_, _, []). 
filter_cards_above_interupt(Lista, [H_dealer|_], [H|T]) :-
    count(H, Lista, Qtd),
    ((H_dealer == H) -> Sum_dealer = 1; Sum_dealer = 0), 
    ((Qtd + Sum_dealer > 4 ) -> false; filter_cards_above_interupt(Lista, [H_dealer], T)). 

check_quantity_card_limits(X, Y) :- 
    filter_cards_above_interupt(X, Y, ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']).

validate_user_cards(X) :- 
    min_len_user_cards(X),
    all_cards_are_valid(X).

validate_dealers_card(Y) :-
    len_dealers_card(Y),
    all_cards_are_valid(Y).

restart_game(Choise) :-
    nl,
    writeln('Jogar Novamente (J)'),
    writeln('Sair (S)'),
    flush_output,
    read_line_to_string(user_input, Raw),
    (   Raw == ""
    ->  restart_game(Choise)
    ;   string_upper(Raw, Upper),
        (   Upper == "J" -> Choise = 'J'
        ;   Upper == "S" -> Choise = 'S'
        ;   writeln('Opção inválida!'), restart_game(Choise)
        )
    ).

game :-
    nl,
    writeln('Insira as Cartas do Jogador: (ex: [A, 2, ..., K].) -> ps: para letras use aspas simples'),
    read(X),
    get_code(_), % <--- Limpa o buffer do Enter
    validate_user_cards(X),
    format('User Cards: ~w~n', [X]),

    writeln('Insira a Carta do Dealer: (ex: [A].) -> ps: para letras use aspas simples'),
    read(Y),
    get_code(_), % <--- Limpa o buffer do Enter
    validate_dealers_card(Y),

    check_quantity_card_limits(X, Y),
    format('Dealers Card: ~w~n', [Y]),

    restart_game(Choise),
    ( Choise == 'J' 
    -> game 
    ;  writeln('Fim do programa, obrigado pela preferência. Ass: CARD-HACK')
    ).


