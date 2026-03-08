:- dynamic user_cards/1. % o predicado é dinamico (pode haver alteração do valor).
:- dynamic dealers_card/1.

len_dealers_card([_]).
min_len_user_cards(X) :-
    length(X, Tam),
    Tam > 1.
    

% Determinar Predicados -> retorna True ou False
game :-
    retractall(user_cards(_)), % apaga as cartas do user, se ainda tiver algo
    retractall(dealers_card(_)), % apaga as cartas do dealer, se ainda tiver algo

    writeln('Insira as Cartas do Jogador: (ex: [A, 2, ..., K].) -> ps: para letras use aspas simples'), % Escreve no Terminal
    read(X),
    min_len_user_cards(X), 
    assertz(user_cards(X)), % isso armazena as cartas do usuario (assertz -> banco de dados dinamico do Pl)
    format('User Cards: ~w', [X]), nl,

    writeln('Insira a Carta do Dealer: (ex: [A].) -> ps: para letras use aspas simples'), % Escreve no Terminal
    read(Y), 
    len_dealers_card(Y), % testa se a qtd de cartas é igual a 1. Se não => False.
    assertz(dealers_card(Y)), % isso armazena as cartas do dealer (assertz -> banco de dados dinamico do Pl)
    format('Dealers Card: ~w', [Y]), nl.

