require 'sinatra'
require 'config_env'
require 'json'
require_relative '../helpers/api_helper'

class ApplicationController < Sinatra::Base
include APIHelper

  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")
  end

  VERSION = 'v1'

  get "/api/#{VERSION}" do
    'NewspaperAPI is up and running.'
  #thin -a 192.168.137.128 -p 8080 start
  end

  get "/api/#{VERSION}/pdf_url" do
    content_type :json
    la_tribuna_config = [ENV['HEADLINE_LIST'], ENV['LOGIN_PAGE'], ENV['FILE_NAME']]
    credentials = [ENV['USERNAME'], ENV['PASSWORD']]
    url = newspaper_url(la_tribuna_config, credentials)
    { URL: url }.to_json
  end

  get "/dir" do
    puts "#{__dir__}"
  end

end
