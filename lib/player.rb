# A player and the token she/he is putting on the board
class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name  = name
    @token = token
  end
end
