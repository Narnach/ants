#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'ai'

ai=AI.new

ai.setup do |ai|
  # your setup code here, if any
end

ai.run do |ai|
  # your turn code here
  agressive = ai.my_ants.size > ai.enemy_ants.size * 1.5
  
  ai.grid.each do |square|
    square.apply_height(4,3) if square.ant? && square.ant.mine?
    if square.ant? && square.ant.enemy?
      if agressive
        square.apply_height(-4, 3)
      else
        square.apply_height(3, 2)
      end
    end
    square.apply_height(-7,6) if square.food?
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