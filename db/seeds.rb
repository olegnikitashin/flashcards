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

user1 = User.create(email: "test1@example.com", password: "foobar", password_confirmation: "foobar")
deck1 = Deck.create(title: "German words", user_id: user1.id)

1.upto(5) do |pagenum|
  page_url = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words-#{pagenum}"

  begin
    page = Nokogiri::HTML(open(page_url))

    path_one = 'div.jsn-article-content table tbody tr.row'
    path_two = 'td.bigLetter'
    path_three = ' + td'

    word_parse = page.css("#{path_one}A #{path_two}") + page.css("#{path_one}B #{path_two}")
    description_parse = page.css("#{path_one}A #{path_two} #{path_three}") + page.css("#{path_one}B #{path_two} #{path_three}")

    words = Hash[word_parse.zip description_parse]

    words.each do |word, definition|
      if definition.text.to_s.length > 2
        user1.cards.create(original_text: word.text, translated_text: definition.text, review_date: Time.now, deck: deck1)
      end
    end

  rescue OpenURI::HTTPError => e
    puts "Can't access #{page_url}"
    puts e.message
    puts
    next
  end
end
