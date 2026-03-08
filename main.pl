:- dynamic user_cards/1. % o predicado é dinamico (pode haver alteração do valor).
:- dynamic dealers_card/1.

len_dealers_card([_]).
min_len_user_cards(X) :-
    length(X, TAM),
    TAM > 1.
all_cards_are_valid(X) :- subset(X, ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']).
 
% Determinar Predicados -> retorna True ou False
game :-
    retractall(user_cards(_)), % apaga as cartas do user, se ainda tiver algo
    retractall(dealers_card(_)), % apaga as cartas do dealer, se ainda tiver algo

    writeln('Insira as Cartas do Jogador: (ex: [A, 2, ..., K].) -> ps: para letras use aspas simples'), % Escreve no Terminal
    read(X),
    min_len_user_cards(X),
    all_cards_are_valid(X), % verifica se todas as cartas é subconjunto das cartas de um baralho.
    assertz(user_cards(X)), % isso armazena as cartas do usuario (assertz -> banco de dados dinamico do Pl)
    format('User Cards: ~w', [X]), nl,

    writeln('Insira a Carta do Dealer: (ex: [A].) -> ps: para letras use aspas simples'), % Escreve no Terminal
    read(Y),
    all_cards_are_valid(Y), % verifica se todas as cartas é subconjunto das cartas de um baralho. 
    len_dealers_card(Y), % testa se a qtd de cartas é igual a 1. Se não => False.
    assertz(dealers_card(Y)), % isso armazena as cartas do dealer (assertz -> banco de dados dinamico do Pl)
    format('Dealers Card: ~w', [Y]), nl.

