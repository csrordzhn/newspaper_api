require 'sinatra'
require 'config_env'
require 'json'
require 'hirb'
require_relative '../helpers/api_helper'

class ApplicationController < Sinatra::Base
include APIHelper

  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")
  end

  configure do
    Hirb.enable
  end

  VERSION = 'v1'

  get "/api/#{VERSION}" do
    'NewspaperAPI is up and running.'
  end

  get "/api/v1/test_url" do
    content_type :json
    { URL: ENV['TEST_URL'] }.to_json
  end

  post "/api/#{VERSION}/pdf_url" do
    content_type :json
    get_newspaper_url(params[:yy], params[:mm], params[:dd])
  end

  post "/api/#{VERSION}/fetch_newspaper" do
    config = [ENV['HEADLINE_LIST'], ENV['LOGIN_PAGE'], ENV['FILE_NAME']]
    access = [ENV['USERNAME'], ENV['PASSWORD']]
    todays_info = newspaper_info(config, access)
    save_url_to_db(todays_info)
  end

end
