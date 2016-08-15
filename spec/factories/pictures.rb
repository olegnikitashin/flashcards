FactoryGirl.define do
  factory :picture do
    photo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/window.jpg')))
  end
end
