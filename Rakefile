def system_puts(cmd)
  puts cmd
  system cmd
end

file "tools" do
  tools_url = "http://aichallengebeta.hypertriangle.com/tools.zip"
  system_puts "wget '#{tools_url}' -O tools.zip && unzip tools.zip && rm tools.zip"
end

task :prepare => "tools"