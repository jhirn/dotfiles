#!/usr/bin/ruby
require "Open3"
require 'fileutils'
require 'shellwords'

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

def ensure_symlink(source_full, target)
  if File.exist?(target) || File.symlink?(target)
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

def create_symlinks
  puts "Creating Symlinks...."
  Dir.glob('./home/*').each do |source|
    basename = File.basename(source)
    next if basename == 'config'

    ensure_symlink(File.expand_path(source), File.join(home, ".#{basename}"))
  end

  create_config_symlinks
end

def create_config_symlinks
  config_home = File.join(home, '.config')
  FileUtils.mkdir_p(config_home)

  if File.symlink?(config_home)
    puts "! #{config_home} is a symlink; expected a real directory."
    return
  end

  puts "Creating ~/.config symlinks...."
  Dir.glob('./home/config/*').each do |source|
    basename = File.basename(source)
    ensure_symlink(File.expand_path(source), File.join(config_home, basename))
  end
end

def install_macos_preferences
  return unless RUBY_PLATFORM.include?('darwin')

  script = File.expand_path('macOS/preferences.sh', __dir__)
  unless File.exist?(script)
    puts "macOS preferences script not found: #{script}"
    return
  end

  puts "Running macOS preferences..."
  run("/bin/bash #{Shellwords.escape(script)}")
end

create_symlinks
puts
install_brew
puts
install_fish
puts
install_macos_preferences
puts
