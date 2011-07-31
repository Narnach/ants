require 'fileutils'
DIRS = %w[replays log]

# I really like to see the commands issued to a terminal for debugging purposes, so use this instead of system.
def system_puts(cmd)
  puts cmd
  system cmd
end

def playgame(options)
  system_puts("tools/playgame.py #{options}")
end

def next_game_id
  Dir.glob("replays/*.replay").map{|path| File.basename(path)}.map{|file| file.to_i}.sort.last.to_i + 1
end

def random_map
  maps = Dir.glob("tools/maps/symmetric_maps/*.map")
  maps[rand(maps.size)]
end

def random_bot_cmd
  bots = [
    'ruby MyBot.rb',
    'python tools/submission_test/TestBot.py'
  ]
  bots += Dir.glob("tools/sample_bots/python/*Bot.py").reject{|path| File.basename(path) =~ /Invalid|Timeout|Error/}.map{|path| "python #{path}"}
  
  bots[rand(bots.size)]
end

desc "Test the current bot to see if it does not crash."
task :test => :prepare do
  puts "="*50
  puts "Play-testing the current bot against the submission test bot, to double-check that our bot does not crash."
  puts "="*50
  puts
  ok = playgame %w[
    --log_error
    --log_stderr
    --nolaunch
    --strict
    --capture_errors
    --engine_seed 42
    --player_seed 42
    --food none
    --end_wait=0.25
    --verbose
    --log_dir log
    --turns 30
    --map_file tools/submission_test/test.map
    --log_stderr
    'ruby MyBot.rb'
    'python tools/submission_test/TestBot.py'
  ].join(" ")
  puts
  puts "="*50
  puts "Done play-testing"
  puts "="*50
  puts
  unless ok
    puts "Play-testing did not return status 0, so something went wrong."
    exit 1
  end
end

desc "Test the current bot to see if it does not crash."
task :play => :prepare do
  map = random_map()
  players = File.read(map).split("\n").grep(/players (\d+)/).first.gsub(/\D/,'').to_i
  p players

  # --capture_errors
  options = %Q[
    --strict
    --verbose
    --game #{next_game_id()}
    --map_file #{map}
    --log_dir replays
    --log_stderr
    'ruby MyBot.rb --log_turn_times'
  ].split("\n").map{|line| line.strip}.join(" ")
  (players-1).times do |n|
    options << " '#{random_bot_cmd()}'"
  end
  ok = playgame(options)
  unless ok
    puts "Game engine did not return status 0, so something went wrong."
    exit 1
  end
end

desc "Zip the current bot so it's ready for submission"
task :zip => :test do
  system_puts "rm -f bot.zip && zip -r -9 bot.zip MyBot.rb lib"
end

desc "Tag the current commit as the next submission"
task :tag do
  submission_id = `git tag -l|grep submission_|sort|tail -n1`.strip.gsub(/\D/,'').to_i+1
  system_puts "git tag -a submission_#{submission_id} HEAD -m 'Submission #{submission_id}'"
end

desc "Archive the current bot and open the bot upload page"
task :upload => [:zip, :tag] do
  system_puts("open http://aichallengebeta.hypertriangle.com/submit.php")
end

desc "Prepare the working directory to play Ants. Will do nothing if the directory is ready."
task :prepare => ["tools"] + DIRS

desc "Setup the tools directory. If missing, downloads tools.zip from the beta website and extracts it."
file "tools" do
  tools_url = "http://aichallengebeta.hypertriangle.com/tools.zip"
  system_puts "wget '#{tools_url}' -O tools.zip && unzip tools.zip && rm tools.zip"
end

DIRS.each do |dir|
  desc "Create the #{dir} directory"
  file dir do
    FileUtils.mkdir_p(dir)
  end
end
