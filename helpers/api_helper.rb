require_relative '../services/fetch_newspaper_from_website'

module APIHelper

  def newspaper_info(config, access)
    newspaper_info = FetchNewspaper.new.call(config, access)
  end


end
