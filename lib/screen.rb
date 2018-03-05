require 'colorize'
require_relative './player'

module Screen
  COLORS = %i[
    light_cyan
    red
    yellow
    green
    white
  ]

  def self.display(board)
    clear

    grid     = board.grid
    length   = grid.size
    cell_num = 1

    tokens = grid.flatten.uniq

    grid.each do |row|
      puts delimiter(length)
      print '|'

      row.each do |cell|
        if cell
          color = COLORS[tokens.rindex(cell)]
          print " #{cell.colorize(color)} |"
        else
          print " #{cell_num} |"
        end

        cell_num += 1
      end

      puts
    end

    puts delimiter(length)
    puts
  end

  def self.delimiter(length)
    "+#{'---+' * length}"
  end

  def self.prompt(player)
    puts "[#{player.name}] Place token (#{player.token}) at: "
    STDIN.gets.chomp.to_i - 1 # we offer human-friendly interaction
  end

  def self.create_player(number)
    puts "P#{number} name: "
    name = STDIN.gets.chomp
    puts "P#{number} token (1 character, e.g., 'X'): "
    token = STDIN.gets.chomp[0]
    puts
    Player.new(name, token)
  end

  def self.victory(board, player)
    display(board)
    puts "#{player.name} won the game!"
  end

  def self.tie(board)
    display(board)
    puts 'Nobody won...'
  end

  def self.error(error)
    puts "\n#{error}! Let's try again...\n\n"
  end

  def self.bye
    puts "\n\nQuitting Tic-Tac-Toe by Mickael Pham"
  end

  def self.new_game?
    puts "\n\nPlay another game? (y/N)"
    STDIN.gets.chomp.casecmp('y').zero?
  end

  def self.clear
    if RUBY_PLATFORM.match?(/win32|win64|\.NET|windows|cygwing|mingw32/i)
      system 'cls'
    else
      system 'clear'
    end
  end
end
