[![Build Status][build_status]][travis]

# Tic-Tac-Toe

A classic game implemented in Ruby.

## Getting started

```sh
git clone https://github.com/mickaelpham/tic-tac-toe
cd tic-tac-toe
bundle install
bundle exec rake play
```

## Features

- [x] Display board, prompt for player names
- [x] Board checks for victory or tie conditions
- [x] Main game loop
- [x] Handle exception (input check)
- [x] Prompt for another game with the same players
- [x] Colorize player tokens in a different color
- [x] Thorough test coverage (100%)

### Tests

```sh
# run the linters and specs
bundle exec rake
# open the code coverage report
open coverage/index.html
```

## Screenshots

Player prompt

<img src="/img/screen-01.png?raw=true" alt="screen-01" width="490">

During the game

<img src="/img/screen-02.png?raw=true" alt="screen-02" width="490">

<img src="/img/screen-03.png?raw=true" alt="screen-03" width="490">

Victory screen

<img src="/img/screen-04.png?raw=true" alt="screen-04" width="490">

Tie screen

<img src="/img/screen-05.png?raw=true" alt="screen-05" width="490">

[build_status]: https://travis-ci.org/mickaelpham/tic-tac-toe.svg?branch=master
[travis]:       https://travis-ci.org/mickaelpham/tic-tac-toe
