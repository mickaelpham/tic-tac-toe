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
    grid.each do |row|
      val = row[0]
      next unless val
      return true if row.all? { |cell| cell == val }
    end

    false
  end

  def col?
    first_row = grid[0]

    first_row.each_with_index do |val, col_index|
      next unless val
      col = grid.collect { |row| row[col_index] }
      return true if col.all? { |cell| cell == val }
    end

    false
  end

  def main_diagonal?
    val = grid[0][0]
    return false unless val

    (1..(grid.size - 1 )).each do |index|
      return false if grid[index][index] != val
    end

    true
  end

  def anti_diagonal?
    index = grid.size - 1
    val   = grid[index][0]
    return false unless val

    (1..index).each do |current|
      return false if grid[index - current][current] != val
    end

    true
  end
end
