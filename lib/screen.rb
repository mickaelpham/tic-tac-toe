require 'pp'
require_relative './player'

module Screen
  def self.display(board)
    pp board
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
end
