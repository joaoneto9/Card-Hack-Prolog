:- use_module('./game_loop').

% executar automaticamente assim que o arquivo for carregado.
% Neste caso, inicia o ciclo principal do jogo de Blackjack.
:- initialization(game_loop()).