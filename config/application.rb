require 'rubygems'
require 'bundler/setup'
require 'json'
require 'active_record'
require "sinatra/namespace"
require 'net/http'

Bundler.require(:default)

require_relative '../communication_app'

Dir['./lib/email_services/*.rb'].each {|file| require file }
Dir['./models/*.rb'].each {|file| require file }
