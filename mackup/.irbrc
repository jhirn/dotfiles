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

puts "Successfully loaded irbrc"
IRB.conf[:USE_AUTOCOMPLETE] = false
