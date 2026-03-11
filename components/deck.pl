:- module(deck, [
    generate_deck/1,
    remove_cards/3,
    get_by_key/3,
    how_many_cards/3,
    total_cards_in_deck/2,
    cards_list/1
]).

% Define a lista estática de símbolos (faces) das cartas disponíveis.
cards_list(['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'K', 'Q', 'A']).

% Cria um baralho novo onde cada carta da cards_list começa com 4 unidades.
% O Deck resultante é uma lista de pares no formato [Carta-4, ...].
generate_deck(Deck) :-
    cards_list(Cards),
    maplist(init_card, Cards, Deck).

% Predicado auxiliar para inicializar uma carta individual com o valor 4.
init_card(Card, Card-4).

% Remove uma lista de cartas de um baralho existente.
% Se a carta existir e a quantidade for > 0, decrementa o valor.
% Caso a carta não esteja no mapa, ela é ignorada.
remove_cards([], Deck, Deck).
remove_cards([H|T], DeckMap, FinalDeck) :-
    (string(H) -> atom_string(Key, H) ; Key = H),
    (select(Key-V, DeckMap, Rest) 
        -> (V > 0 -> NewV is V - 1 ; NewV = 0),
           remove_cards(T, [Key-NewV|Rest], FinalDeck)
        ;  remove_cards(T, DeckMap, FinalDeck)
    ).

% Busca a quantidade disponível de uma carta específica (Key) no baralho.
% Se a chave não for encontrada, retorna 0.
get_by_key(Key, DeckMap, Value) :-
    (member(Key-V, DeckMap) -> Value = V; Value = 0).

% Soma a quantidade disponível de uma lista específica de cartas dentro do baralho.
% Útil para verificar, por exemplo, quantas cartas de um subgrupo ainda restam.
how_many_cards([], _, 0).
how_many_cards([H|T], DeckMap, Total) :-
    get_by_key(H, DeckMap, Count),
    how_many_cards(T, DeckMap, Rest),
    Total is Count + Rest.

% Calcula o número total de cartas restantes em todo o baralho.
% Ele percorre a lista padrão (cards_list) e soma os valores atuais no DeckMap.
total_cards_in_deck(DeckMap, Total) :-
    cards_list(Cards),
    how_many_cards(Cards, DeckMap, Total).