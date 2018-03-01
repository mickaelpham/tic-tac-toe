require_relative './board'
require_relative './player'
require_relative './screen'

class Game
  DEFAULT_BOARD_DIMENSION = 3
  NUM_PLAYERS             = 2

  attr_reader :board, :players, :current_player

  def initialize
    @board   = Board.new(DEFAULT_BOARD_DIMENSION)
    @players = []

    NUM_PLAYERS.times { |num| players << Screen.create_player(num + 1) }

    @current_player = 0
  rescue Interrupt
    Screen.bye
    abort
  end

  def run
    until board.victory? || board.full?
      player = players[current_player]
      Screen.display(board)

      position = Screen.prompt(player)

      board.place(
        player.token,
        position / DEFAULT_BOARD_DIMENSION,
        position % DEFAULT_BOARD_DIMENSION
      )

      victory = board.victory?

      Screen.victory(board, player) if victory
      Screen.tie(board) if !victory && board.full?

      next_player
    end

    new_game if Screen.new_game?
  rescue Board::BoardError => error
    Screen.error(error)
    retry
  rescue Interrupt
    Screen.bye
    abort
  end

  private

  def next_player
    if (current_player + 1) == players.size
      @current_player = 0
    else
      @current_player += 1
    end
  end

  def new_game
    @board          = Board.new(DEFAULT_BOARD_DIMENSION)
    @current_player = 0
    run # FIXME: possible stack overflow if we play enough games
  end
end
