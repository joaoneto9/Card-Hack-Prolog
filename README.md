<h1 align="center">Card-Hack-Prolog</h1>

_Blackjack_, também conhecido como "21", é um jogo de cartas bastante popular em cassinos e casas de aposta no mundo todo. Suas regras simples podem esconder sua natureza probabilística interessante. Nesse sentido, _Card-Hack_ implementa, em _Prolog_, um algoritmo de probabilidades que determina a melhor jogada possível em um contexto de rodadas de _Blackjack_.

---

## Sumário

 - [Estrutura de diretórios](#estrutura-de-diretórios)
 - [Blackjack: objetivos e movimentos](#blackjack-objetivos-e-movimentos)
 - [Cálculo de probabilidades](#cálculo-de-probabilidades)
 - [Executando o algoritmo](#executando-o-algoritmo)
 - [Contribuidores deste repositório](#contribuidores-deste-repositório)

## Estrutura de diretórios

_Card-Hack_ possui três diretórios principais:


| Diretório | Conteúdo |
| --------- | -------- |
| **components** | Contém os arquivos que representam componentes centrais do algoritmo |
| **util** | Contém módulos (arquivos) auxiliares do algoritmo |


Visualmente, a hierarquia de diretórios tem a seguinte forma:

```diff
.
├── main.pl
├── game_loop.pl
├── components/
│   ├── deck.pl
│   ├── prob_algorithm.pl
│   └── prob_interpreter.pl
└── util/
    └── auxiliary_functions.pl
```

## Blackjack: objetivos e movimentos

Antes de tudo, é preciso compreender quem são as figuras que compõem uma mesa de _Blackjack_. São eles:

 - **Dealer**: representa a casa de apostas (cassino). Joga sempre após o(s) jogador(es) e possui uma vantagem inata em jogos de azar: a chamada _house-edge_.
 - **Jogador(es)**: busca(m), de maneira individual, vencer o dealer. Joga(m) sempre antes do _Dealer_.

Nesse sentido, os objetivos de _Blackjack_ são bem simples e diretos. Em suma, é preciso:

 - Possuir um valor exato de 21 pontos ao somar os valores de suas cartas ("_Blackjack_!") **OU**
 - Possuir um somatório de valor de cartas superior ao do _Dealer_ ao fim de uma rodada **E**
 - Não extrapolar os 21 pontos no somatório.

É importante destacar que uma rodada é constituída pela jogada de todos os jogadores e do _Dealer_.

### Movimentos de Blackjack considerados em _Card-Hack_

_Blackjack_ possui inúmeras variações ao redor do mundo e, consequentemente, diversos movimentos podem ser adicionados para tornar o jogo mais dinâmico ou difícil. No caso de _Card-Hack_, serão considerados apenas 2 movimentos, que podem ser realizados tanto pelo jogador quanto pelo _Dealer_:

 - **Stay**: a pessoa do turno não pega nenhuma carta do baralho e passa a vez;
 - **Hit**: a pessoa do turno puxa uma carta do baralho e verifica as condições de vitória.

## Cálculo de probabilidades

Ao final da execução do algoritmo pelo módulo `ProbAlgorithm.hs`, uma tupla de elemento do tipo _Double_ é retornada, contendo respectivamente: **a probabilidade de o jogador vencer em sua próxima jogada caso opte pelo _hit_** e **a probabilidade de o jogador vencer em sua próxima jogada caso opte pelo _stay_**.

### Vencer com _hit_ (_get_)

Para que o jogador vença com um _hit_ em sua próxima jogada, 2 cenários devem ser considerados:

 - Antes de jogar, o jogador possui **menos** pontos do que o _Dealer_; -> P(menos)
 - Antes de jogar, o jogador possui **mais** pontos do que o _Dealer_. -> P(mais)

Como exemplo para demonstrar os cálculos realizados em `ProbAlgorithm.hs`, consideremos a probabilidade de o jogador vencer em sua próxima jogada caso opte por _hit_ e possua menos pontos do que o _Dealer_. Nesse caso, tem-se:

### Vencer com _stay_

Para que vença o _stay_ em sua próxima jogada, apenas um caso é considerado:

 - Antes de jogar, o jogador possui **mais** pontos do que o _Dealer_.

É válido pontuar que o caso em que o jogador possui **menos** pontos do que o _Dealer_ não é considerado pois, nesse caso, caso o jogador opte por _stay_, basta o _Dealer_ também optar por _stay_, e o jogador será derrotado.

Para exemplificar nossos casos, consideremos então o caso válido. Nesse caso, a probabilidade de o jogador vencer em sua próxima jogada optando por _stay_ é:

**ProbVitoria = Probabilidade de o _Dealer_ pegar uma carta e ficar abAixo da pontuação do jogador**

### Componentes importantes

 - `auxiliary_functions.pl`: módulo auxiliar que contém predicados auxiliares para os componentes principais da aplicação;
 - `deck.pl`: módulo auxiliar que representa um baralho (_deck_) convencional. Fundamental para a contagem de cartas no cálculo das probabiliades;
 - `prob_algorithm.pl`: módulo lógico que calcula efetivamente todas as probabilidades a partir de predicaods auxiliares como `underflow_prob`, `blackjack_prob` e `overflow_prob`;
 - `prob_interpreter.pl`: módulo intermediário responsável por tratar as probabilidades recebidas do módulo lógico e devolver uma mensagem ao usuário da aplicação;

## Executando o algoritmo

_Card-Hack-Prolog_ foi construído utilizando _Prolog_, uma linguagem de programação que segue o paradigma lógico. Deve-se, antes de tudo, garantir que o interpretador esteja funcionando em sua máquina. Você pode instalá-lo [**aqui**](https://www.swi-prolog.org/Download.html).

### Acessando diretório raiz do projeto

Primeiro clone o repositório de _Card-Hack-Prolog_:

```bash
git clone https://github.com/joaoneto9/Card-Hack-Prolog.git
```

Depois acesse o diretório raiz do projeto:

```bash
cd ./Card-Hack-Prolog/
```

### Carregando base de conhecimento e executando predicado `main`

Para carregar a base de conhecimento e já executar o arquivo principal, basta rodar:

```bash
swipl main.pl
```

Caso deseje executar os passos separadamente, tente:

```bash
swipl
```

E, na interface no interpretador:

```diff
1 ?- [main].
```

### Informações importantes

Um menu interativo será apresentado. Aqui, duas informações merecem destaque:

 - Consideramos que o jogador possui duas ou mais cartas, sempre;
 - Consideramos que o _Dealer_ posssui apenas uma carta (a carta que fica com a face voltada para cima no início do jogo, de acordo com as regras do _Blackjack_)

Agora, basta se divertir e ganhar todas no _Blackjack_!

## Contribuidores deste repositório

 - [Guilherme Noronha](https://github.com/guinoronhaf)
 - [João Ventura](https://github.com/joaoneto9)
 - [Lucas Cunha](https://github.com/Lucas-Cunhaa)
 - [Matteus Marinho](https://github.com/matteuscantisani)
 - [Pedro Trovão](https://github.com/PedroBMTrovao)

 ---

Repositório construído como trabalho da disciplina de Pardigmas de Linguagens de Programação, ministrado pelo Prof. Ricardo Oliveira durante o período 2025.2, no curso de Ciência da Computação da Universidade Federal de Campina Grande (UFCG).
