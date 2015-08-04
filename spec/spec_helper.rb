ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each {|file| require file }
require './application.rb'

set :views, 'views'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with(:rspec) { |c| c.syntax = :should }
end

