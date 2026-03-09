:- module(auxiliary_functions, [
    truncate_at/3,
    random_int/3,
    split/3,
    sum_cards/2
    ]).

truncate_at(X, N, Result) :-
    Factor is 10 ** N,
    Result is floor(X * Factor) / Factor.

random_int(Low, Hight, Result) :- % nem precisava mapear, mas para manter as regras de negocios dos nomes dos predicados, vai ser assim
    random_between(Low, Hight, Result). 
     
split(Text, Separator, List) :- % nem precisava mapear a resolução em haskell, mas para manter a regra de negocio...
    atomic_list_concat(List, Separator, Text).

get_str_value('A', 11).
get_str_value(X, Result) :- ((member(X, ['J', 'Q', 'K']) -> Result = 10; Result = X)).

count(X, Lista, Result) :- 
    include(==(X), Lista, Filter_list),
    length(Filter_list, Result).
    

sum_cards(Lista, Result) :-
    maplist(get_str_value, Lista, List_maped),
    count('A', Lista, Aces_qauntity),
    sum_list(List_maped, Sum_before_adj),
    adjust_aces(Sum_before_adj, Aces_qauntity, Result),
    !.
    

adjust_aces(Sum, Aces_qtd, Sum) :-
    (Sum =< 21 ; Aces_qtd =:= 0), 
    !.

adjust_aces(Sum, Aces_qtd, Result) :-
    NewTotal is Sum - 10,
    NewAces is Aces_qtd - 1,
    adjust_aces(NewTotal, NewAces, Result).