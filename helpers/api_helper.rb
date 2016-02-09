require_relative '../services/init'

module APIHelper

  def newspaper_info(config, access)
    FetchNewspaperFromSite.new.call(config, access)
  end

  def save_url_to_db(pdf_info)
    SaveNewspaperToDB.new.call(pdf_info)
  end

  def get_newspaper_url(*date)
    FetchNewspaperFromDB.new.call(date)
  end

end
