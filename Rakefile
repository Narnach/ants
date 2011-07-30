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

desc "Test the current bot to see if it does not crash."
task :test => :prepare do
  puts "="*50
  puts "Play-testing the current bot against the submission test bot, to double-check that our bot does not crash."
  puts "="*50
  puts
  ok = playgame %w[
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
