#!/usr/bin/ruby

# Inspired by https://apple.stackexchange.com/questions/41743/how-do-i-speed-up-new-terminal-tab-loading-time
#

fish_path = `which fish`

def has_line?(file, regex)
  File.read(file).include?(regex)
end

def append(file, line)
  File.open(file, "a") do |f|
    f.puts line
  end
end

if fish_path == ""
  puts "Fish shell not found"
  exit 1
end

if File.read("/etc/shells").include?(fish_path)
  puts "Fish shell exists in /etc/shells"
else
  puts "Adding fish to /etc/shells"
  #append ("/etc/shells", fish_path)
end
