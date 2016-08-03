# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rubygems'
require 'nokogiri'
require 'open-uri'


1.upto(10) do |pagenum|
  page_url = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words-#{pagenum}"

  begin
    page = Nokogiri::HTML(open(page_url))
    word_parse = page.css('div.jsn-article-content table tbody tr.rowA td.bigLetter') + page.css('div.jsn-article-content table tbody tr.rowB td.bigLetter')
    description_parse = page.css('div.jsn-article-content table tbody tr.rowA td.bigLetter + td') + page.css('div.jsn-article-content table tbody tr.rowB td.bigLetter + td')
    words = Hash[word_parse.zip description_parse]

    words.each do |word, definition|
      if definition.text.to_s.length > 2
        Card.create( original_text: word.text, translated_text: definition.text, review_date: Time.now )
      end
    end

  rescue OpenURI::HTTPError => e
    puts "Can't access #{page_url}"
    puts e.message
    puts
    next
  end
end
