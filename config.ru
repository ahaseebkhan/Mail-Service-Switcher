require './config/application.rb'

use Rack::Parser, content_types: {
  'application/json' => Proc.new { |body| ::MultiJson.decode body }
}

run CommunicationApp
