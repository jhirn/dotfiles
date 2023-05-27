
# See: https://github.com/pry/pry/issues/2185#issuecomment-945082143
ENV["PAGER"] = " less --raw-control-chars -F -X"

if defined?(PryByebug) || defined?(PryNav)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'q', 'quit'
else
  puts "no pry installed"
end

Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black

# if defined?(ActiveRecord)
#   ActiveRecord::Base.logger = nil
#   ActiveRecord::Base.logger.level = 0 if defined?(ActiveRecord)
# end

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

puts "Successfully loaded ~/.pryrc"

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
