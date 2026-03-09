:- module(prob_algorithm, [calculate_probs/3]).

:- use_module(deck).
:- use_module('../util/auxiliary_functions').

is_blackjack(Cards) :-
    sum_cards(Cards, 21).

is_overflow(Cards) :-
    sum_cards(Cards, Sum),
    Sum > 21.

overflow_prob(Cards, Limit, Deck, Prob) :-
    sum_cards(Cards, CurrentSum),
    Edge is Limit - CurrentSum,
    (   Edge =< 0
    ->  Prob = 1.0
    ;   cards_list(AllPossible),
        findall(C, (member(C, AllPossible), get_str_value(C, V), V > Edge), MatchingCards),
        how_many_cards(MatchingCards, Deck, Count),
        total_cards_in_deck(Deck, Total),
        (Total > 0 -> Prob is Count / Total ; Prob = 0.0)
    ).

underflow_prob(Cards, Limit, Deck, Prob) :-
    sum_cards(Cards, CurrentSum),
    Edge is Limit - CurrentSum,
    (   Edge =< 0
    ->  Prob = 0.0
    ;   MaxVal is Edge - 1,
        (   MaxVal >= 10
        ->  cards_list(MatchingCards)
        ;   findall(NAtom, (between(2, MaxVal, N), atom_number(NAtom, N)), Numbers),
            append(Numbers, ['A'], MatchingCards)
        ),
        how_many_cards(MatchingCards, Deck, Count),
        total_cards_in_deck(Deck, Total),
        (Total > 0 -> Prob is Count / Total ; Prob = 0.0)
    ).

blackjack_prob(Cards, Deck, Prob) :-
    sum_cards(Cards, CurrentSum),
    Target is 21 - CurrentSum,
    (   between(2, 9, Target) -> atom_number(S, Target), MatchingCards = [S]
    ;   (Target =:= 1 ; Target =:= 11) -> MatchingCards = ['A']
    ;   Target =:= 10 -> MatchingCards = ['10', 'J', 'Q', 'K']
    ;   MatchingCards = []
    ),
    how_many_cards(MatchingCards, Deck, Count),
    total_cards_in_deck(Deck, Total),
    (Total > 0 -> Prob is Count / Total ; Prob = 0.0).

average_prob_user_interface(UserCards, DealerCards, Result) :-
    average_prob_user(UserCards, DealerCards, 50, 0, (0.0, 0.0), Result).

average_prob_user(_, _, Limit, Limit, (AccGet, AccStay), (FinalGet, FinalStay)) :-
    FinalGet is AccGet / Limit,
    FinalStay is AccStay / Limit, !.

average_prob_user(UserCards, DealerCards, Limit, Iter, (AccGet, AccStay), Result) :-
    prob_user(UserCards, DealerCards, (ProbGet, ProbStay)),
    NewAccGet is AccGet + ProbGet,
    NewAccStay is AccStay + ProbStay,
    NextIter is Iter + 1,
    average_prob_user(UserCards, DealerCards, Limit, NextIter, (NewAccGet, NewAccStay), Result).

prob_user(UserCards, DealerCards, (ProbGetTrunc, ProbStayTrunc)) :-
    sum_cards(UserCards, SumUser),
    (   SumUser >= 21 
    ->  ProbGetTrunc = 0.0, ProbStayTrunc = 100.0 
    ;   generate_deck(StarterDeck),
        append(UserCards, DealerCards, AllKnown),
        remove_cards(AllKnown, StarterDeck, UpdatedDeck),

        UnderflowEdge is 21 - SumUser - 1,
        (   UnderflowEdge >= 10
        ->  cards_list(EdgeCards)
        ;   findall(NAtom, (between(2, UnderflowEdge, N), atom_number(NAtom, N)), Nums),
            append(['A'], Nums, EdgeCards)
        ),

        length(EdgeCards, L),
        ( L > 0 ->
            Upper is L - 1,
            random_int(0, Upper, RndIdx),
            nth0(RndIdx, EdgeCards, RandomElement),

            append(UserCards, [RandomElement], UserCardsAfterPick),
            sum_cards(UserCardsAfterPick, SumAfterPick),
            remove_cards([RandomElement], UpdatedDeck, DeckAfterPick),

            underflow_prob(DealerCards, SumUser, UpdatedDeck, StayProbVal),
            ProbStay is StayProbVal * 100,

            sum_cards(DealerCards, SumDealer),
            (   SumUser > SumDealer
            ->  (underflow_prob(UserCards, 21, UpdatedDeck, P1),
                 underflow_prob(DealerCards, SumAfterPick, DeckAfterPick, P2),
                 blackjack_prob(UserCards, UpdatedDeck, P3),
                 PickProbVal is (P1 * P2 + P3))
            ;   (overflow_prob(UserCards, SumDealer, UpdatedDeck, P1),
                 underflow_prob(UserCardsAfterPick, 21, DeckAfterPick, P2),
                 underflow_prob(DealerCards, SumAfterPick, DeckAfterPick, P3),
                 blackjack_prob(UserCards, UpdatedDeck, P4),
                 PickProbVal is (P1 * P2 * P3 + P4))
            ),
            ProbPick is PickProbVal * 100,
            truncate_at(ProbPick, 2, ProbGetTrunc),
            truncate_at(ProbStay, 2, ProbStayTrunc)
        ;   ProbGetTrunc = 0.0, ProbStayTrunc = 100.0
        )
    ).

calculate_probs(UserCards, DealerCards, (FinalGet, FinalStay)) :-
    sum_cards(UserCards, TotalUser),
    (   TotalUser =:= 21
    ->  FinalGet = 0.0, FinalStay = 100.0
    ;   TotalUser > 21
    ->  FinalGet = 0.0, FinalStay = 0.0
    ;   average_prob_user_interface(UserCards, DealerCards, (RawGet, RawStay)),
        truncate_at(RawGet, 2, FinalGet),
        truncate_at(RawStay, 2, FinalStay)
    ).
