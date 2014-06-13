require 'io/console'

class Game
  
  def initialize
    b = Board.new
    b.set_board(:white)
    b.set_board(:black)
    @cursor = [4,4]
    play_game
  end
  
  def play_game
  end
  
  def get_input(input)
    
    case input.to_s
    when 'w'
      move([0, -1])
    when 'a'
      move_cursor([-1, 0])
    when 's'
      move_cursor([0, 1])
    when 'd'
      move_cursor([1, 0])
    when 'q'
      @quit = true
    when 'c'
      @move_from = [@cursor_pos[0],@cursor_pos[1]]
      display_board(@cursor_pos, @move_from)
    when 'v'
      @move_to = [@cursor_pos[0], @cursor_pos[1]]
    end
  end
end