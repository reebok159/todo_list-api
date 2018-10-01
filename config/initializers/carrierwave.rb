CarrierWave.configure do |config|
  config.storage = :file if Rails.env.development? || Rails.env.test?
  config.storage = :fog if Rails.env.production?

  config.fog_provider = 'fog/google'
  config.fog_credentials = {
    provider: 'Google',
    google_storage_access_key_id: ENV.fetch('google_storage_access_key_id'),
    google_storage_secret_access_key: ENV.fetch('google_storage_secret_access_key')
  }
  config.fog_directory = ENV.fetch('google_storage_fog_directory')
end
