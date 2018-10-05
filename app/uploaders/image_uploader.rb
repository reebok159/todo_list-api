class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def size_range
    0..10.megabytes
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fit: [200, 150]
  end

  def extension_whitelist
    %w[jpg jpeg png]
  end
end
