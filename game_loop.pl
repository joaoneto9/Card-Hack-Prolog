:- use_module('./util/auxiliary_functions').
:- use_module('./components/prob_algorithm').

len_dealers_card([_]).
all_cards_are_valid(X) :- subset(X, ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']).
min_len_user_cards(X) :-
    length(X, TAM),
    TAM > 1.

filter_cards_above_interupt(_, _, []). 
filter_cards_above_interupt(Lista, [H_dealer|_], [H|T]) :-
    el_count(H, Lista, Qtd),
    ((H_dealer == H) -> Sum_dealer = 1; Sum_dealer = 0), 
    ((Qtd + Sum_dealer > 4 ) -> false; filter_cards_above_interupt(Lista, [H_dealer], T)). 

check_quantity_card_limits(X, Y) :- 
    filter_cards_above_interupt(X, Y, ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']).

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

game_loop :-
    writeln('Insira as Cartas do Jogador: (separe por espaço " ")'),
    read_line_to_string(user_input, X),
    split(X, ' ', User_cards),
    validate_user_cards(User_cards),
    format('User Cards: ~w', [User_cards]), nl,

    writeln('Insira a Carta do Dealer: (ex: [A].) -> ps: para letras use aspas simples'),
    read_line_to_string(user_input, Y),
    read_line_to_string(user_input, Y),
    split(Y, ' ', Dealers_card),
    validate_dealers_card(Y),

    check_quantity_card_limits(User_cards, Dealers_card),
    format('Dealers Card: ~w', [Dealers_card]), nl,

	calculate_probs(User_cards, Dealers_card, (Get, Stay)),
	format('Get prob: ~w', Get), nl,
	format('Stay prob: ~w', Stay), nl,

    restart_game(Choise),
    (Choise == 'J' -> game_loop; 
                    writeln('Fim do programa, obrigado pela preferência. Ass: CARD-HACK')).
