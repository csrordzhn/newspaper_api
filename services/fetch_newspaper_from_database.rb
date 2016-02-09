require './models/newspaper_url'

class FetchNewspaperFromDB

  def call(*date)
    get_newspaper_url(date)
  end

  private

  def get_newspaper_url(*date)

    date_params = date.flatten.compact

    url = "about:blank"
    url = NewspaperURL.last.pdf_url if date_params.empty? #no date given
    newspaper = NewspaperURL.where(year: date_params[0], month: date_params[1], day: date_params[2]).first
    url = newspaper.pdf_url if newspaper

    { URL: url }.to_json

  end
end
