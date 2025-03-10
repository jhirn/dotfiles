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

puts "Creating Symlinks...."
Dir.glob('./home/*').each do |source|
  # Get the basename of the source
  basename = File.basename(source)

  # Create the target path in home directory with a dot prefix
  target = File.join(home, ".#{basename}")

  # Get absolute path of source
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
    # Create the symlink
    File.symlink(source_full, target)
    puts "✓ Created symlink: #{target} -> #{source_full}"
  end
end
