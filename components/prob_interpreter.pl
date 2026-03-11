:- module(prob_interpreter, [probAnalise/3]).

% atomic_list_concat/2 (Caso Base): Define que a concatenação de uma lista vazia é uma string vazia.
atomic_list_concat([], '').

% atomic_list_concat/2: Concatena recursivamente uma lista de átomos em um único átomo/string resultante.
atomic_list_concat([H|T], R) :-
    atomic_list_concat(T, TR),
    atom_concat(H, TR, R).

% showProbs/3: Formata a exibição textual das porcentagens de probabilidade de "puxar" e "manter".
showProbs(X, Y, P) :-
    atomic_list_concat([
        'Probabilidade ao puxar uma carta: ', X, '%\n',
        'Probabilidade ao manter as cartas: ', Y, '%\n'
    ], P).

% probAnalise/3 (Caso Estouro): Trata o cenário onde ambas as probabilidades são zero (usuário já ultrapassou 21).
probAnalise(0.00, 0.00, R) :- R = 'OverFlow da quantidade de pontos do usuário, impossível tomar alguma ação.\nProbabilidade ao puxar uma carta: 0.00%\nProbabilidade ao manter as cartas: 0.00%\n'.

% probAnalise/3 (Caso Dealer Superior): Trata o cenário onde manter a mão resulta em derrota certa (Stay = 0%).
probAnalise(X, 0.00, R) :- format(string(R), 
            'Pontuação inferior que o Dealer, assim: Observa-se que a probabilidade de vencer sem puxar nenhuma carta é nula. Sendo assim, você deve puxar uma carta.\nProbabilidade ao puxar uma carta: ~2f%\nProbabilidade ao manter as cartas: 0.00%\n', 
            [X]).
            
% probAnalise/3 (Caso Blackjack): Trata o cenário de pontuação máxima (21), onde o risco de puxar é absoluto.
probAnalise(0.00, 100.00, R) :- R = 'Você alcançou Blackjack, 21 pontos. Apenas aguarde sua vitória e não puxe nenhuma carta. (espero não ter zicado, pois o Dealer pode conseguir fazer Blackjack também).\nProbabilidade ao puxar uma carta: 0.00%\nProbabilidade ao manter as cartas: 99.99%\n'.

% probAnalise/3: Calcula a diferença entre as probabilidades para decidir qual conselho fornecer através do predicado analyze.
probAnalise(X, Y, R) :- Diff is X - Y,
    showProbs(X, Y, P),
    analyze(Diff, P, R).

% analyze/3: Sugestão quando "puxar" (Get) é ligeiramente melhor (diferença entre 5% e 10%).
analyze(D, P, R) :- D =< 10.0, D >= 5.0, !,
    atomic_list_concat(['As probabilidades indicam que existe uma grande semelhança,\ncontudo a probabilidade de puxar uma carta é um pouco melhor:\n', P], R).
    
% analyze/3: Sugestão quando "manter" (Stay) é ligeiramente melhor (diferença entre -5% e -10%).
analyze(D, P, R) :- D >= -10.0, D =< -5.0, !,
    atomic_list_concat(['As probabilidades indicam que apresenta uma grande semelhança,\ncontudo a probabilidade de não puxar uma carta (stay) é um pouco melhor:\n', P], R).

% analyze/3: Caso de incerteza/equilíbrio (diferença menor que 5%).
analyze(D, P, R) :- D > -5.0, D < 5.0, !,
    atomic_list_concat(['Praticamente a mesma probabilidade, vai na fé irmão:\n', P], R).
    
% analyze/3: Recomendação forte para "puxar" uma carta (diferença maior que 10%).
analyze(D, P, R) :- D > 10.0, !,
    atomic_list_concat(['Diferença considerável entre as probabilidades,\nindicando que a melhor ação é puxar uma carta:\n', P], R).
    
% analyze/3: Recomendação forte para "manter" a mão (diferença menor que -10%).
analyze(D, P, R) :- D < -10.0, !,
    atomic_list_concat(['Diferença considerável entre as probabilidades,\nindicando que a melhor ação é não puxar uma carta (stay):\n', P], R).