require 'json'
require_relative '../newspaper'

module PDFHelper

  def newspaper_url
    pdf = Newspaper.new(ENV['HEADLINE_LIST'],ENV['LOGIN_PAGE'], ENV['FILE_NAME'], ENV['USERNAME'], ENV['PASSWORD']
    )
    { URL: pdf.pdf_file_url }.to_json
  end

  # local
  def pdf_file_download(agent, headline_page)
    file_name = headline_page.link_with(:href => (Regexp.new ENV['FILE_NAME'])).href
    Kernel.system("curl -o LaTribunaDeHoy.pdf '#{file_name}'") # download pdf
    logout(agent, headline_page)
  end
  def get_pdf_file
    agent = Mechanize.new
    headline_pg = headline_page(agent, headline_title)
    pdf_file_download(agent, headline_pg)
  end
  # local

end
