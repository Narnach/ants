#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'ai'

ai=AI.new

ai.setup do |ai|
  # your setup code here, if any
end

ai.run do |ai|
  # your turn code here
  
  ai.grid.each do |square|
    if square.ant?
      if square.ant.enemy?
        square.apply_height(3, 2)
      else
        square.apply_height(2, 1)
      end
    end
    square.apply_height(9,0) if square.water?
    square.apply_height(-3,2) if square.food?
  end

  ai.my_ants.each do |ant|
    # Don't double-move an ant
    next if ant.moved?

    # Use flow to check which direction to go
    possible_directions = ant.square.flow_directions
    direction = possible_directions.first
    ant.order(direction) if direction
  end
end