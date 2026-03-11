:- module(game_loop, [game_loop/0]).

:- use_module('./util/auxiliary_functions').
:- use_module('./components/prob_algorithm').
:- use_module('./components/prob_interpreter').

% len_dealers_card/1: Verifica se a lista da carta do dealer contém exatamente um elemento.
len_dealers_card([_]).

% all_cards_are_valid/1: Garante que todos os elementos da lista X pertençam ao conjunto de cartas permitidas (A, 2-10, J, Q, K).
all_cards_are_valid(X) :- subset(X, ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']).

% min_len_user_cards/1: Valida se o jogador possui pelo menos duas cartas para iniciar a análise.
min_len_user_cards(X) :-
    length(X, TAM),
    TAM > 1.

% filter_cards_above_interupt/3 (Caso Base): Interrompe a recursão quando a lista de cartas a verificar está vazia.
filter_cards_above_interupt(_, _, []). 

% filter_cards_above_interupt/3: Verifica recursivamente se a quantidade de uma carta específica (H) 
% somando as mãos do jogador e do dealer excede o limite de 4 unidades por baralho.
filter_cards_above_interupt(Lista, [H_dealer|_], [H|T]) :-
    el_count(H, Lista, Qtd),
    ((H_dealer == H) -> Sum_dealer = 1; Sum_dealer = 0), 
    ((Qtd + Sum_dealer > 4 ) -> false; filter_cards_above_interupt(Lista, [H_dealer], T)). 

% check_quantity_card_limits/2: Orquestra a verificação de limite de cartas (máximo 4 de cada) para todas as cartas possíveis do baralho.
check_quantity_card_limits(X, Y) :- 
    filter_cards_above_interupt(X, Y, ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']).

% validate_user_cards/1: Agrupa as regras de validação para as cartas do jogador (mínimo de cartas e símbolos válidos).
validate_user_cards(X) :- 
    min_len_user_cards(X),
    all_cards_are_valid(X).

% validate_dealers_card/1: Agrupa as regras de validação para a carta do dealer (apenas uma carta e símbolo válido).
validate_dealers_card(Y) :-
    len_dealers_card(Y),
    all_cards_are_valid(Y).

% restart_game/1: Gerencia a interface de repetição do jogo, tratando entradas do usuário (J para jogar, S para sair) e erros de digitação.
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

% game_loop/0: Predicado principal que coordena o fluxo do programa: leitura de inputs, 
% validações, chamada dos algoritmos de probabilidade e reinicialização.
game_loop :-
    writeln('Insira as Cartas do Jogador: (separe por espaço " ")'),
    read_line_to_string(user_input, X),
    split(X, ' ', User_cards),
    validate_user_cards(User_cards),

    writeln('Insira a Carta do Dealer: (Digite apenas uma)'),
    read_line_to_string(user_input, Y), nl,
    atom_string(Dearlers_card_atom, Y),
    Dealers_card = [Dearlers_card_atom], % padronizado em tratar com listas.
    validate_dealers_card(Dealers_card),

    check_quantity_card_limits(User_cards, Dealers_card),

    calculate_probs(User_cards, Dealers_card, (Get, Stay)),
    probAnalise(Get, Stay, Analyze_probs),
    format('~w', Analyze_probs), nl,

    restart_game(Choise),
    (Choise == 'J' -> nl, game_loop; 
                    writeln('Fim do programa, obrigado pela preferência. Ass: CARD-HACK')).