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
    setup_players
  rescue Interrupt
    Screen.bye
    abort
  end

  # rubocop:disable Metrics/MethodLength
  def run
    until board.victory? || board.full?
      prompt_player
      end_of_turn
    end

    new_game if Screen.new_game?
  rescue Board::BoardError => error
    Screen.error(error)
    retry
  rescue Interrupt
    Screen.bye
    abort
  end
  # rubocop:enable Metrics/MethodLength

  private

  def setup_players
    NUM_PLAYERS.times { |num| players << Screen.create_player(num + 1) }
    @current_player = players.first
  end

  def next_player
    index           = players.rindex(current_player) + 1
    @current_player = players.fetch(index, players.first)
  end

  def prompt_player
    Screen.display(board)
    position = Screen.prompt(current_player)
    board.place(
      current_player.token,
      position / DEFAULT_BOARD_DIMENSION,
      position % DEFAULT_BOARD_DIMENSION
    )
  end

  def end_of_turn
    victory = board.victory?
    Screen.victory(board, current_player) if victory
    Screen.tie(board) if !victory && board.full?
    next_player
  end

  def new_game
    @board          = Board.new(DEFAULT_BOARD_DIMENSION)
    @current_player = players.first
    run # FIXME: possible stack overflow if we play enough games
  end
end
