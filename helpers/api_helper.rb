require_relative '../models/newspaper'

module APIHelper

  def newspaper_url(config, access)
    la_tribuna = Newspaper.new(config[0], config[1], config[2], access[0], access[1])
    la_tribuna.pdf_file_url
  end

end
