# The board game
class Board
  # Best practice to raise from a common inherited error
  class BoardError < StandardError; end

  # Raised when a token is already present at the coordinates
  class TokenPresent < BoardError; end

  # Raised when the coordinates are out of the board
  class OutOfBoard < BoardError; end

  # Raised when the initial dimensions are not positive integers
  class InvalidDimension < BoardError; end

  attr_reader :grid, :moves

  def initialize(dimension)
    raise InvalidDimension unless dimension.positive?

    @grid  = Array.new(dimension) { Array.new(dimension) }
    @moves = 0
  end

  def place(token, row, col)
    raise OutOfBoard, "row: #{row}; col: #{col} invalid" if out?(row, col)
    target_row = grid[row]
    raise TokenPresent if target_row[col]
    target_row[col]  = token
    @moves          += 1
  end

  def victory?
    row? || col? || main_diagonal? || anti_diagonal?
  end

  def full?
    moves >= (grid.size ** 2)
  end

  private

  def out?(row, col)
    row < 0 || row >= grid.size || col < 0 || col >= grid[0].size
  end

  def row?
    grid.each { |row| return true if row.uniq.first }
    false
  end

  def col?
    grid.size.times { |index| return true if column(index).uniq.first }
    false
  end

  # Extract the n column from the grid
  def column(index)
    grid.collect { |row| row[index] }
  end

  def main_diagonal?
    grid.collect.with_index do |_val, index|
      grid[index][index]
    end.uniq.first
  end

  def anti_diagonal?
    grid.collect.with_index do |_val, index|
      opposite_index = grid.size - 1 - index
      grid[opposite_index][opposite_index]
    end.uniq.first
  end
end
