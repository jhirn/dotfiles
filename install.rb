#!/usr/bin/ruby
require "Open3"
require 'fileutils'
home = File.expand_path('~')

 def command?(command)
  system("which #{ command} > /dev/null 2>&1")
 end

 def run_cmd(cmd)
  Open3.popen2e(cmd) do |stdin, stdout_stderr, wait_thread|
    Thread.new do
      stdout_stderr.each { |l| puts l }
    end

    stdin.puts 'ls'
    stdin.close

    wait_thread.value
  end
end

if ARGV.include?("--brew")
  if !command?("brew")
    puts "Installing homebrew..."
    run_cmd('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
  else
    puts "Homebrew exists, skipping"
  end
  run_cmd("brew install mackup fish")
end

File.read("/etc/shells").include?("#{`brew --prefix`.chomp}/bin/fish")
FileUtils.ln_s("./mackup/.mackup.cfg", "~/.mackup.cfg")
run_cmd("mackup restore -f")
