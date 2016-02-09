require './models/newspaper_url'

class SaveNewspaperToDB

  def call(newspaper_info)
    save_to_db(newspaper_info)
  end

  private

  def save_to_db(newspaper_info)
    todays = NewspaperURL.new
    todays.headline = newspaper_info[:headline]
    todays.pdf_url = newspaper_info[:URL]
    todays.year = newspaper_info[:year]
    todays.month = newspaper_info[:month]
    todays.day =newspaper_info[:day]
    todays.save!
  end

end
