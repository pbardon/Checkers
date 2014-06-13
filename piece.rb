#encoding: utf-8

require './board'

class Piece
  
  attr_reader :color, :position
  
  def initialize(pos, board, color)
    @board_obj = board
    @position = pos
    @color = color
    @king = false
    set_position(@position)
  end
  
  def inspect
    if @color == :black
      (@king ? "♔" : "◯")
    else
      (@king ? "♚" : "⬤")
    end
  end
  
  def perform_slide(to_pos)
 
    raise "Those are invalid moves" if !valid_moves?(@position) || !valid_moves?(to_pos)
    
    possible_moves = []
    
    if @king
      move_diffs.each do |dif| 
        possible_moves << [(@position.first + dif.first), (@position.last + dif.last)]
      end
      
    else  
      difs = ((@color == :black) ? move_diffs.drop(2) : move_diffs.take(2))

    
      difs.each do |dif| 
        pos = [(@position.first + dif.first), (@position.last + dif.last)]
        possible_moves << pos
      end
      p "possible_moves:#{possible_moves}"
    end
    
    raise "That is an illegal move" if !possible_moves.include?(to_pos)
    raise "There is a piece there" if !@board_obj[to_pos].nil?
    
    @board_obj[@position] = nil
    set_position(to_pos)
    
  end

  
  def perform_jump(to_pos)
    
    puts "Those are invalid moves" if !valid_moves?(@position) || !valid_moves?(to_pos)
    
    difs = ((@color == :black) ? move_diffs.drop(2) : move_diffs.take(2))
    jumpable_tiles = []
    
    difs.each do |diffs|
      pos = [(@position.first + diffs.first) , (@position.last + diffs.last)]
      jumpable_tiles << pos
    end  
    
    jumped_piece_pos = nil
    
    jump_pieces = jumpable_tiles.select do |pos| 
      @board_obj[pos].is_a?(Piece) && @board_obj[pos].color != @color
    end
   
    if (@position.first - to_pos.first).abs != 2 && (@position.last - to_pos.last).abs != 2
     puts "That's an illegal jump, from #{@position} to #{to_pos}"
      
    elsif !jumpable_tiles.empty?
      puts "position is #{@position}"
      
      p "try to jump from #{@position} to #{to_pos}"

      
      new_x = (to_pos.first + @position.first) / 2
      new_y = (to_pos.last + @position.last) / 2
      
      
      jumped_piece_pos = [new_x, new_y]
      
      p "jumped piece #{jumped_piece_pos}, and I am #{object_id}"
      
      @board_obj[jumped_piece_pos] = nil
      
      set_position(to_pos)
      
    else
      puts "Can't jump! No piece there"
    end
  end
  
  def perform_moves(move_seq)
    p "move seq: (btw I am #{object_id})"
    if valid_move_seq?(move_seq)
      perform_moves!(move_seq)
    else
      puts "Valid_move_seq is fucked"
    end
  end
  
  def perform_moves!(move_seq)
    p "i am #{object_id} and I am performing moves!"
    if move_seq.length == 1
      current_move = move_seq.first
      begin
        puts "try to slide"
        perform_slide(current_move)
      rescue
        puts "try to jump"
        p current_move
        perform_jump(current_move) 
       ## raise InvalidMoveError.new
      end
    else
      move_seq.each do |current_move|
        perform_jump(current_move)
      end
    end
    p "i am #{object_id} and I have finished performing moves!"
  end
  
  def valid_move_seq?(seq)
    duped_board = @board_obj.dup
    dup_piece = Piece.new(@position, duped_board, self.color)
    begin
      puts "try to perform moves"
      p seq
      dup_piece.perform_moves!(seq)
      return true
    rescue StandardError => e
      puts e.message
      return false
    end
  end
  
  def promote_piece
    (color == :white) ? promote_y = 0 : promote_y = 7
    ((self.position.last == promote_y) ? @king = true : @king = false )
  end
  
  private
  
  
  def set_position(pos)
    @board_obj[@position] = nil
    @board_obj[pos] = self
    @position = pos
  end
  
  def move_diffs
    diffs = [[ 1,  1],
             [-1,  1],
             [-1, -1],
             [ 1, -1]]
  end
  
  def valid_moves?(pos)
    pos.first.between?(0, 7) && pos.last.between?(0, 7)
  end
  
end

class InvalidMoveError < StandardError
  def message
    puts "That move was invalid"
  end
end