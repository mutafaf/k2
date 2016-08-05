CarrierWave.configure do |cfg|
  if Rails.env.production?
    cfg.storage = :fog
    cfg.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.secrets.AWS_ACCESS_ID,
      :aws_secret_access_key  => Rails.application.secrets.AWS_ACCESS_SECRET
    }
    cfg.fog_directory  = Rails.application.secrets.AWS_BUCKET
    cfg.fog_public     = true
    cfg.fog_attributes = {'Cache-Control'=>'max-age=315576000'}

  elsif Rails.env.staging?
    cfg.storage = :fog
    cfg.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.secrets.AWS_ACCESS_ID,
      :aws_secret_access_key  => Rails.application.secrets.AWS_ACCESS_SECRET
    }
    cfg.fog_directory  = Rails.application.secrets.AWS_BUCKET
    cfg.fog_public     = true
    cfg.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  else
    cfg.storage = :file
  end

  cfg.enable_processing = !Rails.env.test?
end