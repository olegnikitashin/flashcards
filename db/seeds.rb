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
    a = page.css('div.jsn-article-content table tbody tr.rowA td.bigLetter')
    b = page.css('div.jsn-article-content table tbody tr.rowA td.bigLetter + td')
    c = page.css('div.jsn-article-content table tbody tr.rowB td.bigLetter')
    d = page.css('div.jsn-article-content table tbody tr.rowB td.bigLetter + td')
    words_a = Hash[a.zip b]
    words_b = Hash[c.zip d]

    words_a.each do |word, definition|
      if definition.text.to_s.length > 2
        Card.create( original_text: word.text, translated_text: definition.text, review_date: Time.now )
      end
    end

    words_b.each do |word, definition|
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
