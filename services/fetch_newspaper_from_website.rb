require 'mechanize' # http://mechanize.rubyforge.org/GUIDE_rdoc.html
require 'open-uri'
require 'oga'

class FetchNewspaperFromSite

  def call(config, credentials)
    @agent = Mechanize.new
    @headline_list = config[0]
    @login_page = config[1]
    @file_name = config[2]
    @username = credentials[0]
    @password = credentials[1]
    newspaper_info = post_info
    newspaper_info[:URL] = pdf_file_url
    newspaper_info
  end

  private

  def pdf_file_url
    headline_title = post_info[:headline]
    newspaper_page = get_headline_page(headline_title)
    file_name = newspaper_page.link_with(:href => (Regexp.new @file_name)).href
    logout(newspaper_page)
    file_name
  end

  def post_info
    # Navigate to the latest headline (does not require login).
    web_data = open(@headline_list)
    document = Oga.parse_html(web_data)
    post_list = document.xpath("//div[contains(@class,'category-pdf')]")
    post_title = post_list.first.xpath('h2/a').text
    post_ts = post_list.first.xpath('div')[0].children[1].children[0].attributes[1].text
    pdf_date = Date.parse(post_ts)
    { headline: post_title, year: pdf_date.year, month: pdf_date.month, day: pdf_date.day }

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

  def logout(headline_page)
    @agent.click(headline_page.link_with(:text => /Logout/)) # => Logged out!
    @agent.history.clear
    @agent.cookies.clear
  end

end
