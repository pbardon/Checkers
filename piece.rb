#encoding: utf-8

require './board'

class Piece
  
  attr_reader :color, :pos
  
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
  
  def perform_slide(from_pos, to_pos)
    
  ##  add_moves = Proc.new(possible_moves << [(from_pos.first + dif.first), (from_pos.last + dif.last)])
    
    raise "Those are invalid moves" if !valid_moves?(from_pos) || !valid_moves?(to_pos)
    
    possible_moves = []
    
    if @king
      
      move_diffs.each do |dif| 
        possible_moves << [(from_pos.first + dif.first), (from_pos.last + dif.last)]
      end
      
    else  
      
      difs = ((@color == :black) ? move_diffs.drop(2) : move_diffs.take(2))
      
      difs.each do |dif| 
        pos = [(from_pos.first + dif.first), (from_pos.last + dif.last)]
        possible_moves << pos
      end
      
    end
    p possible_moves
    raise "That is an illegal move" if !possible_moves.include?(to_pos)
    raise "There is a piece there" if !@board_obj[to_pos].nil?
    
    @board_obj[from_pos] = nil
    set_position(to_pos)
    
  end

  
  def perform_jump(from_pos, to_pos)
    raise "Those are invalid moves" if !valid_moves?(from_pos) || !valid_moves?(to_pos)
    
    jumpable_tiles = []
    
    move_diffs.each do |diffs|
      pos = [(from_pos.first + diffs.first) , (from_pos.last + diffs.last)]
      jumpable_tiles << pos
    end  
    
    jumped_piece_pos = nil
    
    jump_pieces = jumpable_tiles.select do |pos| 
      @board_obj[pos].is_a?(Piece) && @board_obj[pos].color != @color
    end
    
    if (from_pos.first - to_pos.first).abs != 2 && (from_pos.last - to_pos.last).abs != 2
      raise "That's an illegal jump"
    elsif !jump_pieces.empty?
      @board_obj[from_pos] = nil
      dx = (to_pos.first - from_pos.first) / 2
      dy = (to_pos.last - from_pos.last) / 2
      jumped_piece_pos = [(from_pos.first + dx), (from_pos.last + dy)]
      @board_obj[jumped_piece_pos] = nil
      set_position(to_pos)
    else
      raise "Can't jump! No piece there"
    end
  end
  
  def perform_moves(move_seq)
    if valid_move_seq?(move_seq)
      perform_moves!(move_seq)
    else
      raise InvalidMoveError.new
    end
  end
  
  def perform_moves!(move_seq)
    if move_seq.length < 2
      begin
        perform_slide(move_seq.first,  move_seq.last )
      rescue
        ##raise InvalidMoveError.new
        perform_jump( move_seq[0].first,  move_seq[0].last ) 
      end
    else
      until move_seq.empty?
        begin
          current_move = move_seq.shift
          perform_jump(current_move.first,  current_move.last)
        rescue
          raise InvalidMoveError.new
        end
      end
    end
  end
  
  def valid_move_seq?(seq)
    duped_board = @board_obj.dup
    dup_piece = Piece.new(@position, duped_board, self.color)
    begin
      dup_piece.perform_moves!(seq)
      return true
    rescue
      return false
    end
  end
  
  def promote_piece
    (color == :white) ? promote_y = 0 : promote_y = 7
    ( (self.position.last == promote_y) ? @king = true : @king = false )
  end
  
  private
  
  
  def set_position(pos)
    x, y = pos
    @board_obj[pos] = self
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