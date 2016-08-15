CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    PictureUploader

    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?
      klass.class_eval do
        def cache_dir
          "#{Rails.root}/spec/support/uploads/tmp"
        end

        def store_dir
          "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
        end
      end
    end

  else
    config.storage = :fog
  end

  config.fog_credentials = {
    provider:              'AWS',                         # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],      # required
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],  # required
    region:                'eu-central-1',                   # optional, defaults to
  }

  config.fog_directory  = 'onflashcards'                                   # required
  config.fog_public     = false                                            # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end
