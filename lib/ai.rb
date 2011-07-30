require 'core_ext'
require 'grid'
require 'square'
require 'ant'

class AI
  # Grid that represents the map
  attr_accessor :grid
  # Number of current turn. If it's 0, we're in setup turn. If it's :game_over, you don't need to give any orders; instead, you can find out the number of players and their scores in this game.
  attr_accessor :turn_number

  # Game settings. Integers.
  attr_accessor :loadtime, :turntime, :rows, :cols, :turns, :viewradius2, :attackradius2, :spawnradius2, :seed, :player_seed
  # Radii, unsquared. Floats.
  attr_accessor :viewradius, :attackradius, :spawnradius

  # Number of players. Available only after game's over.
  attr_accessor :players
  # Array of scores of players (you are player 0). Available only after game's over.
  attr_accessor :score

  # Return an array of alive ants
  attr_reader :my_ants, :enemy_ants

  # Initialize a new AI object. Arguments are streams this AI will read from and write to.
  def initialize stdin=$stdin, stdout=$stdout
    @stdin, @stdout = stdin, stdout

    @grid=nil
    @turn_number=0

    @my_ants=[]
    @enemy_ants=[]

    @did_setup=false
  end

  # Returns a read-only hash of all settings.
  def settings
    {
      :loadtime => @loadtime,
      :turntime => @turntime,
      :rows => @rows,
      :cols => @cols,
      :turns => @turns,
      :viewradius2 => @viewradius2,
      :attackradius2 => @attackradius2,
      :spawnradius2 => @spawnradius2,
      :viewradius => @viewradius,
      :attackradius => @attackradius,
      :spawnradius => @spawnradius,
      :seed => @seed,
      :player_seed => @player_seed,
    }.freeze
  end

  # Zero-turn logic.
  def setup # :yields: self
    read_intro
    yield self

    @stdout.puts 'go'
    @stdout.flush

    @grid=Grid.new(self.rows, self.cols, self)
    @did_setup=true
  end

  # Turn logic. If setup wasn't yet called, it will call it (and yield the block in it once).
  def run &b # :yields: self
    setup &b if !@did_setup

    over=false
    until over
      over = read_turn
      yield self

      @stdout.puts 'go'
      @stdout.flush
    end
  end

  # Internal; reads zero-turn input (game settings).
  def read_intro
    rd=@stdin.gets.strip
    warn "unexpected: #{rd}" unless rd=='turn 0'

    until((rd=@stdin.gets.strip)=='ready')
      _, name, value = *rd.match(/\A([a-z0-9]+) (\d+)\Z/)

      case name
      when 'loadtime'; @loadtime=value.to_i
      when 'turntime'; @turntime=value.to_i
      when 'rows'; @rows=value.to_i
      when 'cols'; @cols=value.to_i
      when 'turns'; @turns=value.to_i
      when 'viewradius2'; @viewradius2=value.to_i
      when 'attackradius2'; @attackradius2=value.to_i
      when 'spawnradius2'; @spawnradius2=value.to_i
      when 'player_seed'; @player_seed=value.to_i
      when 'seed'; @seed=value.to_i
      else
        warn "unexpected: #{rd}"
      end
    end

    @viewradius=Math.sqrt @viewradius2
    @attackradius=Math.sqrt @attackradius2
    @spawnradius=Math.sqrt @spawnradius2
  end

  # Internal; reads turn input (map state).
  def read_turn
    ret=false
    rd=@stdin.gets.strip

    if rd=='end'
      @turn_number=:game_over

      rd=@stdin.gets.strip
      _, players = *rd.match(/\Aplayers (\d+)\Z/)
      @players = players.to_i

      rd=@stdin.gets.strip
      _, score = *rd.match(/\Ascore (\d+(?: \d+)+)\Z/)
      @score = score.split(' ').map{|s| s.to_i}

      ret=true
    else
      _, num = *rd.match(/\Aturn (\d+)\Z/)
      @turn_number=num.to_i
    end

    # reset the map data
    @grid.reset
    @my_ants=[]
    @enemy_ants=[]

    until((rd=@stdin.gets.strip)=='go')
      _, type, row, col, owner = *rd.match(/(w|f|a|d) (\d+) (\d+)(?: (\d+)|)/)
      row, col = row.to_i, col.to_i
      owner = owner.to_i if owner
      node = self.grid.square(row, col)

      case type
      when 'w'
        node.water=true
      when 'f'
        node.food=true
      when 'a'
        ant=Ant.new(true, owner, node, self)
        node.ant = ant

        if owner==0
          my_ants << ant
        else
          enemy_ants << ant
        end
      when 'd'
        dead_ant=Ant.new(false, owner, node, self)
        node.ant = dead_ant
      when 'r'
        # pass
      else
        warn "unexpected: #{rd}"
      end
    end

    return ret
  end

  # call-seq:
  #   order(ant, direction)
  #
  # Give orders to an ant
  def order(ant, direction)
    @stdout.puts "o #{ant.row} #{ant.col} #{direction.to_s.upcase}"
  end
end
