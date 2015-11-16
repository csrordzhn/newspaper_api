require 'mechanize' # http://mechanize.rubyforge.org/GUIDE_rdoc.html
require 'open-uri'
require 'oga'
require 'json'

module PDFHelper

def headline_title
  # Navigate to the latest headline (does not require login).
  web_data = open(ENV['HEADLINE_LIST'])
  document = Oga.parse_html(web_data)
  pdfs = document.xpath("//div[contains(@class,'category-pdf')]")
  pdfs.first.xpath('h2/a').text
end

def headline_page(agent, headline_title)
  # Login to service
  login_page = agent.get(ENV['LOGIN_PAGE'])
  login_form = login_page.form
  login_form.log = ENV['USERNAME'] # username
  login_form.pwd = ENV['PASSWORD'] # password
  landing_page = agent.submit(login_form) # => logged in!
  agent.click(landing_page.link_with(:text => (Regexp.new headline_title)))
end

def pdf_file_download(agent, headline_page)
  file_name = headline_page.link_with(:href => (Regexp.new ENV['FILE_NAME'])).href
  Kernel.system("curl -o LaTribunaDeHoy.pdf '#{file_name}'") # download pdf
  logout(agent, headline_page)
end

def pdf_file_url(agent, headline_page)
  file_name = headline_page.link_with(:href => (Regexp.new ENV['FILE_NAME'])).href
  logout(agent, headline_page)
  file_name
end

def logout(agent, headline_page)
  agent.click(headline_page.link_with(:text => /Logout/)) # => Logged out!
  clear(agent)
end

def clear(agent)
  # Clear history and cookies
  agent.history.clear
  agent.cookies.clear
end

def get_pdf_file_url
  agent = Mechanize.new
  headline_pg = headline_page(agent, headline_title)
  { url: pdf_file_url(agent, headline_pg)}.to_json
end

def get_pdf_file
  agent = Mechanize.new
  headline_pg = headline_page(agent, headline_title)
  pdf_file_download(agent, headline_pg)
end
end
