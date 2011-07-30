# I really like to see the commands issued to a terminal for debugging purposes, so use this instead of system.
def system_puts(cmd)
  puts cmd
  system cmd
end

desc "Setup the tools directory. If missing, downloads tools.zip from the beta website and extracts it."
file "tools" do
  tools_url = "http://aichallengebeta.hypertriangle.com/tools.zip"
  system_puts "wget '#{tools_url}' -O tools.zip && unzip tools.zip && rm tools.zip"
end

desc "Prepare the working directory to play Ants. Will do nothing if the directory is ready."
task :prepare => "tools"