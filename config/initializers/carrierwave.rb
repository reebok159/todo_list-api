CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    CarrierWave.configure do |config|
      config.storage = :file
    end
  end

  if Rails.env.production?
    CarrierWave.configure do |config|
      config.storage = :fog
    end
  end

  config.fog_provider = 'fog/google'
  config.fog_credentials = {
    provider: 'Google',
    google_storage_access_key_id: ENV.fetch('google_storage_access_key_id'),
    google_storage_secret_access_key: ENV.fetch('google_storage_secret_access_key')
  }
  config.fog_directory = ENV.fetch('google_storage_fog_directory')
end
