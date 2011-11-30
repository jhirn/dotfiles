#!/usr/bin/ruby

home = File.expand_path('~')

Dir['*'].each do |file|
  next if file =~ /install/
  target = File.join(home, ".#{file}")
  `ln -s #{File.expand_path file} #{target}` unless File.exists?(target)
end
