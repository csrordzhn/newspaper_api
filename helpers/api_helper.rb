require 'json'
require_relative '../models/newspaper'

module APIHelper

  def newspaper_url
    pdf = Newspaper.new(ENV['HEADLINE_LIST'],ENV['LOGIN_PAGE'], ENV['FILE_NAME'], ENV['USERNAME'], ENV['PASSWORD'])
    { URL: pdf.pdf_file_url }.to_json
  end

end
