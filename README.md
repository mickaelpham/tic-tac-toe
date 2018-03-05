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
- [ ] Colorize player tokens in a different color
      (Need to change the board to store `Player` references)
- [ ] Needs more test coverage

### Tests

```sh
# run the linters and specs
bundle exec rake
```

## Screenshots

Player prompt

![screen-01](/img/screen-01.png?raw=true)

During the game

![screen-02](/img/screen-02.png?raw=true)

![screen-03](/img/screen-03.png?raw=true)

Victory screen

![screen-04](/img/screen-04.png?raw=true)

Tie screen

![screen-05](/img/screen-05.png?raw=true)

[build_status]: https://travis-ci.org/mickaelpham/tic-tac-toe.svg?branch=master
[travis]:       https://travis-ci.org/mickaelpham/tic-tac-toe
