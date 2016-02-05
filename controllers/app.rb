require 'sinatra'
require 'config_env'
require_relative '../helpers/api_helper'

class ApplicationController < Sinatra::Base
include APIHelper

  configure :development, :test do
    ConfigEnv.path_to_config("./config/config_env.rb")
  end

  get '/api/v1' do
    'NewspaperAPI is up and running.'
  #thin -a 192.168.137.128 -p 8080 start
  end

  get '/api/v1/get_pdf_url' do
    content_type :json
    newspaper_url
  end

end
