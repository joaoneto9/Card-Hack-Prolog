:- module(prob_interpreter, [probAnalise/3]).

atomic_list_concat([], '').

atomic_list_concat([H|T], R) :-
    atomic_list_concat(T, TR),
    atom_concat(H, TR, R).

showProbs(X, Y, P) :-
    atomic_list_concat([
        'Probabilidade ao puxar uma carta: ', X, '%\n',
        'Probabilidade ao manter as cartas: ', Y, '%\n'
    ], P).

probAnalise(0.00, 0.00, R) :- R = 'OverFlow da quantidade de pontos do usuário, impossível tomar alguma ação.\nProbabilidade ao puxar uma carta: 0.00%\nProbabilidade ao manter as cartas: 0.00%\n'.

probAnalise(X, 0.00, R) :- format(string(R), 
            'Pontuação inferior que o Dealer, assim: Observa-se que a probabilidade de vencer sem puxar nenhuma carta é nula. Sendo assim, você deve puxar uma carta.\nProbabilidade ao puxar uma carta: ~2f%\nProbabilidade ao manter as cartas: 0.00%\n', 
            [X]).
            
probAnalise(0.00, 100.00, R) :- R = 'Você alcançou Blackjack, 21 pontos. Apenas aguarde sua vitória e não puxe nenhuma carta. (espero não ter zicado, pois o Dealer pode conseguir fazer Blackjack também).\nProbabilidade ao puxar uma carta: 0.00%\nProbabilidade ao manter as cartas: 99.99%\n'.

probAnalise(X, Y, R) :- Diff is X - Y,
    showProbs(X, Y, P),
    analyze(Diff, P, R).

analyze(D, P, R) :- D =< 10.0, D >= 5.0, !,
    atomic_list_concat(['As probabilidades indicam que existe uma grande semelhança,\ncontudo a probabilidade de puxar uma carta é um pouco melhor:\n', P], R).
    
analyze(D, P, R) :- D >= -10.0, D =< -5.0, !,
    atomic_list_concat(['As probabilidades indicam que apresenta uma grande semelhança,\ncontudo a probabilidade de não puxar uma carta (stay) é um pouco melhor:\n', P], R).

analyze(D, P, R) :- D > -5.0, D < 5.0, !,
    atomic_list_concat(['Praticamente a mesma probabilidade, vai na fé irmão:\n', P], R).
    
analyze(D, P, R) :- D > 10.0, !,
    atomic_list_concat(['Diferença considerável entre as probabilidades,\nindicando que a melhor ação é puxar uma carta:\n', P], R).
    
analyze(D, P, R) :- D < -10.0, !,
    atomic_list_concat(['Diferença considerável entre as probabilidades,\nindicando que a melhor ação é não puxar uma carta (stay):\n', P], R).
