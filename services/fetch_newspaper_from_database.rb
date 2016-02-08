require './models/newspaper_url'

class FetchNewspaperFromDB
  def call(year, month, date)
    get_newspaper_url(year, month, date)
  end

  private

  def get_newspaper_url(year, month, date)
    if year == nil && month == nil && date == nil
      url = NewspaperURL.last
    elsif year == nil || month == nil || date == nil
      url = "about:blank"
    else
      url = NewspaperURL.where(year: params[:yy], month: params[:mm], day: params[:dd]).first.pdf_url
    end
    { URL: url }.to_json
  end
end
