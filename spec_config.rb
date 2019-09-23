ENV['RACK_ENV'] = 'test'
require './config/application.rb'
require 'rspec'
require 'rack/test'
