class AvatarUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # process :convert => 'png'
  # process :tags => ['post_picture']

  # def filename
  #    "original.#{model.logo.file.extension}" if original_filename
  # end

  # Local onde será guardado as imagens
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  version :avatar do
    process :resize_to_fit => [800, 300]
  end

  version :medium do
    process :resize_to_fill => [300, 300]
  end

  version :thumb do
    process resize_to_fill: [200,200]
  end

  version :icon do
    process resize_to_fit: [40, 40]
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path(["logo.png"].compact.join('_'))
    # ActionController::Base.helpers.asset_path([version_name, "logo.png"].compact.join('_'))
  end


  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
