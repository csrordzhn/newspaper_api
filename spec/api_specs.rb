ENV['RACK_ENV'] = 'test'

Dir.glob('./{services/models,helpers,controllers}/init.rb').each { |file| require file }
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

describe 'check features for worker' do
  before do
    NewspaperURL.delete_all
  end

  it 'should fetch url from website and save to db' do
    post "/api/#{VERSION}/fetch_newspaper"
    NewspaperURL.all.count.must_be :==, 1
  end
end

describe 'check features for mobile' do

  before do
    test_news = NewspaperURL.new
    test_news.year = 2016
    test_news.month = 2
    test_news.day = 6
    test_news.pdf_url = "http://cdn.digital.latribuna.hn/wp-content/uploads/2016/02/LA-TRIBUNA-PDF-WEB-06022016TRO.pdf"
    test_news.headline = "Arde bus, se salvan 35 pasajeros"
    test_news.save!
  end


  it 'should return a json with a URL' do
    get "/api/#{VERSION}/test_url"
    last_response.headers['Content-Type'].must_equal 'application/json'
    url = JSON.parse(last_response.body)
    url['URL'].must_match (/http:\/\/(.*)pdf$/)
    #last_response.status.must_equal 200
  end

  it 'should accept url parameters and return a json with a URL' do
    recent = NewspaperURL.last
    post "/api/#{VERSION}/pdf_url?yy=#{recent.year}&mm=#{recent.month}&dd=#{recent.day}"
    last_response.headers['Content-Type'].must_equal 'application/json'
    url = JSON.parse(last_response.body)
    url['URL'].must_match (/http:\/\/(.*)pdf$/)
  end

  it 'should accept no url parameters and return most recent URL' do
    recent = NewspaperURL.last
    post "/api/#{VERSION}/pdf_url"
    last_response.headers['Content-Type'].must_equal 'application/json'
    url = JSON.parse(last_response.body)
    url['URL'].must_equal recent.pdf_url
    #last_response.status.must_equal 200
  end

  it 'should return about:blank for out of bounds' do
    post "/api/#{VERSION}/pdf_url?yy=9999&mm=13&dd=32"
    last_response.headers['Content-Type'].must_equal 'application/json'
    url = JSON.parse(last_response.body)
    url['URL'].must_equal "about:blank"

  end
end
