require_relative './player'

module Screen
  def self.display(board)
    grid   = board.grid
    length = grid.size

    grid.each do |row|
      puts delimiter(length)
      print '|'

      row.each do |cell|
        print cell ? " #{cell} |" : "   |"
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
    gets.chomp.to_i
  end

  def self.create_player(number)
    puts "P#{number} name: "
    name = gets.chomp
    puts "P#{number} token (1 character, e.g., 'X'): "
    token = gets.chomp[0]
    puts
    Player.new(name, token)
  end

  def self.victory(board, player)
    display(board)
    puts "#{player.name} won the game!"
  end

  def self.tie(board)
    display(board)
    puts "Nobody won..."
  end
end
