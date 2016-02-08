require 'mechanize' # http://mechanize.rubyforge.org/GUIDE_rdoc.html
require 'open-uri'
require 'oga'

class FetchNewspaper

  def call(config, credentials)
    @agent = Mechanize.new
    @headline_list = config[0]
    @login_page = config[1]
    @file_name = config[2]
    @username = credentials[0]
    @password = credentials[1]
    pdf_info = [headline_title, pdf_file_url]
  end

  private

  def headline_title
    # Navigate to the latest headline (does not require login).
    web_data = open(@headline_list)
    document = Oga.parse_html(web_data)
    pdfs = document.xpath("//div[contains(@class,'category-pdf')]")
    pdfs.first.xpath('h2/a').text
  end

  def get_headline_page(headline_title)
    # Login to service
    login_page = @agent.get(@login_page)
    login_form = login_page.form
    login_form.log = @username # username
    login_form.pwd = @password # password
    landing_page = @agent.submit(login_form) # => logged in!
    @agent.click(landing_page.link_with(:text => (Regexp.new headline_title)))
  end

  def pdf_file_url
    todays_headline = headline_title
    newspaper_page = get_headline_page(todays_headline)
    file_name = newspaper_page.link_with(:href => (Regexp.new @file_name)).href
    logout(newspaper_page)
    file_name
  end

  def logout(headline_page)
    @agent.click(headline_page.link_with(:text => /Logout/)) # => Logged out!
    @agent.history.clear
    @agent.cookies.clear
  end

end
