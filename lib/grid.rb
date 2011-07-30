require 'square'

class Grid
  attr_accessor :grid, :rows, :cols

  def initialize(rows, cols, ai)
    @rows, @cols, @ai = rows, cols, ai
    @grid = Array.new(@rows){|row| Array.new(@cols){|col| Square.new(false, false, nil, row, col, ai) } }
  end

  def reset
    @grid.each do |row|
      row.each do |square|
        square.reset
      end
    end
  end

  # If row or col are greater than or equal map width/height, makes them fit the map.
  #
  # Handles negative values correctly (it may return a negative value, but always one that is a correct index).
  #
  # Returns [row, col].
  def normalize(row, col)
    [row % @rows, col % @cols]
  end

  # Access a square via normalized coordinates. Use this instead of @grid[row][col].
  def square(row, col)
    row, col = normalize(row, col)
    @grid[row][col]
  end
end