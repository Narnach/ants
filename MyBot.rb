#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'ai'

ai=AI.new
ai.log_turn_times = ARGV.include?("--log_turn_times")

ai.setup do |ai|
  @food_attract_radius = ai.viewradius.ceil.to_i
  $stderr.puts "Food rd: #{@food_attract_radius}"
  @enemy_distance = ai.attackradius.ceil.to_i
  $stderr.puts "Enemy rd: #{@enemy_distance}"
end

ai.run do |ai|
  @agressive = ai.my_ants.size > ai.enemy_ants.size * 2

  ai.grid.each do |square|
    square.apply_height(4,3) if square.ant? && square.ant.mine?
    if square.ant? && square.ant.enemy?
      if @agressive
        square.apply_height(-(@enemy_distance+1), @enemy_distance)
      else
        square.apply_height(@enemy_distance+1, @enemy_distance)
      end
    end
    square.apply_height(-(@food_attract_radius+1),@food_attract_radius) if square.food?
  end

  ai.my_ants.each_with_index do |ant, index|
    $stderr.puts "Processing ant: #{index}"
    # Don't double-move an ant
    next if ant.moved?

    # Use flow to check which direction to go
    possible_directions = ant.square.flow_directions
    direction = possible_directions.first
    ant.order(direction) if direction
  end
end