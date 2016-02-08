require 'sinatra'
require 'config_env'
require 'json'
require './models/newspaper_url'
require './services/fetch_newspaper_from_website'
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

  get "/api/v1/test_url" do
    content_type :json
    { URL: NewspaperURL.first.pdf_url }.to_json
  end

  get "/api/#{VERSION}/pdf_url" do
    content_type :json
    la_tribuna_config = [ENV['HEADLINE_LIST'], ENV['LOGIN_PAGE'], ENV['FILE_NAME']]
    credentials = [ENV['USERNAME'], ENV['PASSWORD']]
    todays_info = newspaper_info(la_tribuna_config, credentials)
    todays = NewspaperURL.new
    todays.headline = todays_info[0]
    todays.pdf_url = todays_info[1]
    todays.year = Date.today.year
    todays.month = Date.today.month
    todays.day = Date.today.day
    todays.save!
    { URL: todays.pdf_url }.to_json
  end

  post "/api/v1/fetch_newspaper" do
    "route for worker"
  end

end
