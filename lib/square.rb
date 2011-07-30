# Represent a single field of the map.
class Square
  # Ant which sits on this square, or nil. The ant may be dead.
  attr_accessor :ant, :inbound_ant
  # Which row this square belongs to.
  attr_accessor :row
  # Which column this square belongs to.
  attr_accessor :col

  attr_accessor :water, :food, :ai

  def initialize water, food, ant, row, col, ai
    @water, @food, @ant, @row, @col, @ai = water, food, ant, row, col, ai
  end

  # Returns true if this square is not water. Square is passable if it's not water, it doesn't contain alive ants and it doesn't contain food.
  def land?; !@water; end
  # Returns true if this square is water.
  def water?; @water; end
  # Returns true if this square contains food.
  def food?; @food; end
  # Returns true if an ant is moving to this square
  def inbound_ant?; @inbound_ant; end

  # Is the square non-occupied land?
  def free?
    land? && !ant? && !inbound_ant?
  end

  # Returns true if this square has an alive ant.
  def ant?; @ant and @ant.alive?; end;

  # Returns a square neighboring this one in given direction.
  def neighbor direction
    direction=direction.to_s.upcase.to_sym # canonical: :N, :E, :S, :W

    case direction
    when :N
      row, col = @ai.normalize @row-1, @col
    when :E
      row, col = @ai.normalize @row, @col+1
    when :S
      row, col = @ai.normalize @row+1, @col
    when :W
      row, col = @ai.normalize @row, @col-1
    else
      raise 'incorrect direction'
    end

    return @ai.map[row][col]
  end

  def reset
    self.food=false
    self.ant=nil
    self.inbound_ant=nil
  end
end
