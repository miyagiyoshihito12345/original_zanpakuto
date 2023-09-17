require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_directory  = 'originalzanpakuto' # 作成したバケット名を記述
  config.fog_public = false
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.aws[:access_key_id],#AWSのaccess_key_id
    aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],#AWSのsecret_access_key
    region: 'ap-northeast-1',   # アジアパシフィック(東京)を選択した場合
    path_style: true
  }
end 
