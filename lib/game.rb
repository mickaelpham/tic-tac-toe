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

    @current_player = players[0]
  end

  def run
    until board.victory? || board.full?
      Screen.display(board)

      position = Screen.prompt(current_player)

      board.place(
        current_player.token,
        position / DEFAULT_BOARD_DIMENSION,
        position % DEFAULT_BOARD_DIMENSION
      )
    end
  end
end
