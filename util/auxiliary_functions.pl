:- module(auxiliary_functions, [
	el_count/3,
    truncate_at/3,
    random_int/3,
    split/3,
    sum_cards/2,
    get_str_value/2
    ]).

el_count(_, [], 0) :- !.
el_count(H, [H|T], R) :-
	el_count(H, T, R2),
	R is 1 + R2.
el_count(H, [_|T], R) :- el_count(H, T, R).

truncate_at(X, N, Result) :-
    Factor is 10 ** N,
    Result is floor(X * Factor) / Factor.

random_int(Low, High, Result) :-
    random_between(Low, High, Result).

split(Text, Separator, List) :-
    atomic_list_concat(List, Separator, Text).

get_str_value(X, 11) :- member(X, ['A', "A"]), !.
get_str_value(X, 10) :- member(X, ['J', 'K', 'Q', '10', "J", "K", "Q", "10"]), !.
get_str_value(X, Result) :-
    (   number(X) -> Result = X
    ;   atom(X)   -> atom_number(X, Result)
    ;   string(X) -> number_string(X, Str), number_string(Result, Str)
    ), !.

is_ace('A').
is_ace("A").

sum_cards(Lista, Result) :-
    maplist(get_str_value, Lista, List_maped),
    include(is_ace, Lista, Aces_list),
    length(Aces_list, Aces_quantity),
    sum_list(List_maped, Sum_before_adj),
    adjust_aces(Sum_before_adj, Aces_quantity, Result), !.

adjust_aces(Sum, Aces_qtd, Sum) :-
    (Sum =< 21 ; Aces_qtd =:= 0), !.
adjust_aces(Sum, Aces_qtd, Result) :-
    NewTotal is Sum - 10,
    NewAces is Aces_qtd - 1,
    adjust_aces(NewTotal, NewAces, Result).
