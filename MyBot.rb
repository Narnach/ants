#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'ai'

ai=AI.new

ai.setup do |ai|
  # your setup code here, if any
end

ai.run do |ai|
  # your turn code here

  ai.my_ants.each do |ant|
    next if ant.moved?
    # Try to move to all directions in a random order
    # Randomizing the order prevents getting stuck in a corner
    [:N, :E, :S, :W].shuffle.each do |dir|
      if ant.square.neighbor(dir).free?
        ant.order dir
        break
      end
    end
  end
end