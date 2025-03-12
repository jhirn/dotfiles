#!/usr/bin/ruby
require "Open3"
require 'fileutils'

def home
   File.expand_path('~')
end

def brew_prefix
   @brew_prefix ||= `brew --prefix`.strip if command?("brew")
end

def command?(command)
  system("which #{ command} > /dev/null 2>&1")
end

def run(cmd)
  Open3.popen2e(cmd) do |stdin, stdout_stderr, wait_thread|
    Thread.new do
      stdout_stderr.each { |l| puts l }
    end
    stdin.puts 'ls'
    stdin.close
    wait_thread.value
  end
end

def install_brew
  if !command?("brew")
    puts "Installing homebrew..."
    run('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
  else
    puts "Homebrew exists, skipping"
  end
end

def install_fish
  homebrew_fish_path = "#{brew_prefix}/bin/fish"
  if ENV["SHELL"] != homebrew_fish_path
    puts "Installing fish via homebrew"
    run("brew install fish")
    run("chsh -s #{homebrew_fish_path}")
  else
    puts "Fish is already the default shell"
  end
end

def create_symlinks
  puts "Creating Symlinks...."
  Dir.glob('./home/*').each do |source|
    basename = File.basename(source)
    target = File.join(home, ".#{basename}")
    source_full = File.expand_path(source)

    if File.exist?(target)
      if File.symlink?(target) && File.readlink(target) == source_full
        puts "✓ #{target} already points to #{source_full}"
      else
        puts "! #{target} already exists but is not a symlink to #{source_full}"
        print "  Overwrite? (y/n): "
        if STDIN.gets.chomp.downcase == 'y'
          FileUtils.rm_rf(target)
          File.symlink(source_full, target)
          puts "  ✓ Created symlink: #{target} -> #{source_full}"
        end
      end
    else
      File.symlink(source_full, target)
      puts "✓ Created symlink: #{target} -> #{source_full}"
    end
  end
end

install_brew
puts
install_fish
puts
create_symlinks
