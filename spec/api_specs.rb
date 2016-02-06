ENV['RACK_ENV'] = 'test'

Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

VERSION = 'v1'

def app
  ApplicationController
end

describe 'check service ' do
  it 'should return ok' do
    get "/api/#{VERSION}"
    last_response.must_be :ok?
  end
end

describe 'check features ' do
  it 'should return a json' do
    get "/api/#{VERSION}/pdf_url"
    last_response.headers['Content-Type'].must_equal 'application/json'
    #last_response.status.must_equal 200
  end
end
