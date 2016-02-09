class CreateNewspaperurls < ActiveRecord::Migration
  def change
    create_table :newspaper_urls do |t|
      t.text :headline
      t.text :pdf_url
      t.integer :year
      t.integer :month
      t.integer :day
      t.timestamps null:false
    end
  end
end
