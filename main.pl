:- use_module('./game_loop').
:- use_module('./components/cardhack_title', [print_card_hack/0]).

% executar automaticamente assim que o arquivo for carregado.
% Neste caso, inicia o ciclo principal do jogo de Blackjack.
main :-
    print_card_hack,
    game_loop.

:- initialization(main).