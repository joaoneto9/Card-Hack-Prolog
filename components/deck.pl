cards_list(["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "K", "Q", "A"]).

generate_deck(Deck) :-
	cards_list(Cards),
	maplist(init_card, Cards, Deck).

init_card(Card, Card-4).

remove_cards([], Deck, Deck).
remove_cards([H|T], DeckMap, FinalDeck) :-
	select(H-V, DeckMap, Rest),
	(V > 0 -> NewV is V - 1 ; NewV = 0),
	remove_cards(T, [H-NewV|Rest], FinalDeck).

get_by_key(Key, DeckMap, Value) :-
	(member(Key-V, DeckMap) -> Value = V; Value = -1).

how_many_cards([], _, 0).
how_many_cards([H|T], DeckMap, Total) :-
	get_by_key(H, DeckMap, Count),
	how_many_cards(T, DeckMap, Rest),
	Total is Count + Rest.

total_cards_in_deck(DeckMap, Total) :-
	cards_list(Cards),
	how_many_cards(Cards, DeckMap, Total).
