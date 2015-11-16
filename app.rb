require 'sinatra'
require 'config_env'
require_relative './helpers/pdf_helper'

class LaTribunaAPI < Sinatra::Base
include PDFHelper

configure :development, :test do
  ConfigEnv.path_to_config("./config/config_env.rb")
end

get '/api/v1' do
  'NewspaperAPI is up and running.'
#thin -a 192.168.137.128 -p 8080 start
end

get '/api/v1/get_pdf_url' do
  get_pdf_file_url
end

post 'api/v1/save' do
  'Save PDF to OneDrive and explain why you are saving it.'
end

end
