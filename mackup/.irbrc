require 'rubygems'


# def see_sql
#   if defined?(ActiveRecord)
#     puts "wth?"
#     # ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
#     # ActiveRecord::Base.logger.level = ActiveSupport::Logger::DEBUG
#   end
# end


# if defined?(Rails)
#   Rails.application.configure do
#     config.after_initialize do
#       # see_sql
#     end
#   end
# end

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
  RubyProf.start
  result = yield
  profiler = RubyProf.stop

  base_dir = "tmp/ruby_prof/#{Time.now.to_i}"
  FileUtils.mkdir_p(base_dir)
  printer = RubyProf::MultiPrinter.new(profiler)
  printer.print(path: base_dir, profile: 'profile')
  `flamegraph.pl --countname=ms --width=1600 #{base_dir}/profile.flat.txt > #{base_dir}/flame_graph.svg`
  puts "Profile written to #{base_dir}"
  result
end

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

# Console only task to update my password
def update_my_password
  User.skip_callback(:update, :after, :send_password_change_notification) rescue nil
  me = User.find_by(email: ENV["MY_EMAIL"])
  if me.nil?
    puts "You don't exist brah"
  else
    me.password = "p"
    me.password_confirmation = "p"
    me.save(validate: false)
  end
  puts "please reload! to reset callbacks."
end

puts "Successfully loaded ~/.irbrc"
