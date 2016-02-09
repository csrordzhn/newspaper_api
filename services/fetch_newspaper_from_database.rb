require './models/newspaper_url'

class FetchNewspaperFromDB

  def call(*date)
    get_newspaper_url(date)
  end

  private

  def get_newspaper_url(*date)

    # date is blank, not date provided with
    url = "about:blank" unless [0,3].include? arr.size
    url = NewspaperURL.last.pdf_url if date.size == 0
    url = NewspaperURL.where(year: date[0], month: date[1], day: date[2]).first.pdf_url if date.size == 3

    { URL: url }.to_json
  end
end
