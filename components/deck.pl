:- module(deck, [
    generate_deck/1,
    remove_cards/3,
    get_by_key/3,
    how_many_cards/3,
    total_cards_in_deck/2,
    cards_list/1
]).

% Usando Átomos para consistência
cards_list(['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'K', 'Q', 'A']).

generate_deck(Deck) :-
    cards_list(Cards),
    maplist(init_card, Cards, Deck).

init_card(Card, Card-4).

remove_cards([], Deck, Deck).
remove_cards([H|T], DeckMap, FinalDeck) :-
    % Garante que tratamos o H como átomo para o match no DeckMap
    (string(H) -> atom_string(Key, H) ; Key = H),
    (select(Key-V, DeckMap, Rest) 
        -> (V > 0 -> NewV is V - 1 ; NewV = 0),
           remove_cards(T, [Key-NewV|Rest], FinalDeck)
        ;  remove_cards(T, DeckMap, FinalDeck) % Se a carta não existe, ignora
    ).

get_by_key(Key, DeckMap, Value) :-
    (member(Key-V, DeckMap) -> Value = V; Value = 0).

how_many_cards([], _, 0).
how_many_cards([H|T], DeckMap, Total) :-
    get_by_key(H, DeckMap, Count),
    how_many_cards(T, DeckMap, Rest),
    Total is Count + Rest.

total_cards_in_deck(DeckMap, Total) :-
    cards_list(Cards),
    how_many_cards(Cards, DeckMap, Total).
