# load libraries

def unbundled_require(gem)
  if defined?(::Bundler)
    spec_path = Dir.glob("#{Gem.dir}/specifications/#{gem}-*.gemspec").last
    if spec_path.nil?
      warn "Couldn't find #{gem}"
      return
    end
    spec = Gem::Specification.load spec_path
    begin
      spec.activate
    rescue LoadError => err
      warn "Couldn't activate #{gem}: #{err}"
      return
    end
  end

  begin
    require gem
    yield if block_given?
  rescue Exception, LoadError => err
    warn "Couldn't load #{gem}: #{err}"
  end
end


require 'rubygems' unless defined? Gem

unbundled_require 'ruby-nuggets'
unbundled_require 'added_methods'
unbundled_require 'pry'
unbundled_require 'brice' do
  Brice.init
end

puts "Successfully loaded irbrc"
