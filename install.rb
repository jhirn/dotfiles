#!/usr/bin/ruby
require "Open3"
home = File.expand_path('~')

 def command?(command)
  system("which #{ command} > /dev/null 2>&1")
 end

 def run_cmd(cmd)
  Open3.popen2e(cmd) do |stdin, stdout_stderr, wait_thread|
    Thread.new do
      stdout_stderr.each {|l| puts l }
    end

    stdin.puts 'ls'
    stdin.close

    wait_thread.value
  end
end

if (!command?("brew"))
  puts "Installing homebrew..."
  run_cmd('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
else
  puts "Homebrew exists, skipping"
 end
 puts "Running Homebrew Bundle..."

run_cmd("brew bundle")

puts "Creating Symlinks...."
Dir['*'].each do |file|
  next if file =~ /install|README/
  target = File.join(home, ".#{file}")
  unless File.exists?(target)
    puts "Creating #{target}"
    run_cmd("ln -s #{File.expand_path file} #{target}")
  end
end

puts "Running OSX applescript settings..."
run_cmd("./osxsettings.applescript")
