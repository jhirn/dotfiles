require 'rubygems'

unless defined?(ActiveRecord)
#  ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT) if defined?(ActiveRecord)
  ActiveRecord::Base.logger.level = 1 if defined?(ActiveRecord)
end

IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:USE_AUTOCOMPLETE] = false

def bm
  # From http://blog.evanweaver.com/articles/2006/12/13/benchmark/
  # Call benchmark { } with any block and you get the wallclock runtime
  # as well as a percent change + or - from the last run
  cur = Time.now
  result = yield
  print "#{cur = Time.now - cur} seconds"
  puts " (#{(cur / $last_benchmark * 100).to_i - 100}% change)" rescue puts ""
  $last_benchmark = cur
  result
end

def with_profiler
  require 'ruby-prof'
  require 'ruby-prof-flamegraph'
  RubyProf.start
  result = yield
  profiler = RubyProf.stop

  base_dir = "tmp/ruby_prof/#{Time.now.to_i}"
  FileUtils.mkdir_p(base_dir)
  File.open("#{base_dir}/graph.html", 'w+') do |file|
    RubyProf::GraphHtmlPrinter.new(profiler).print(file)
  end
  File.open("#{base_dir}/call_stack.html", 'w+') do |file|
    RubyProf::CallStackPrinter.new(profiler).print(file)
  end
  File.open("#{base_dir}/flame_graph.txt", 'w+') do |file|
    RubyProf::FlameGraphPrinter.new(profiler).print(file)
  end
  `flamegraph.pl --countname=ms --width=1600 #{base_dir}/flame_graph.txt > #{base_dir}/flame_graph.svg`
  puts "Profile written to #{base_dir}"
  result
end

IRB.conf[:USE_AUTOCOMPLETE] = false


if defined?(QueryCount)
  def with_query_count
    QueryCount::Counter.reset_counter
    yield
    puts "Number of queries executed: #{QueryCount::Counter.counter}"
  end
end

module Kernel
  def lc
    caller.grep(/#{Rails.root}/)
  end
end

class StandardError
  def lt
    backtrace.grep(/#{Rails.root}/)
  end
end


def bm
  # From http://blog.evanweaver.com/articles/2006/12/13/benchmark/
  # Call benchmark { } with any block and you get the wallclock runtime
  # as well as a percent change + or - from the last run
  cur = Time.now
  result = yield
  print "#{cur = Time.now - cur} seconds"
  puts " (#{(cur / $last_benchmark * 100).to_i - 100}% change)" rescue puts ""
  $last_benchmark = cur
  result
end

puts "Successfully loaded ~/.irbrc"
