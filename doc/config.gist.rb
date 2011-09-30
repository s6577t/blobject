MyApplication::Config = ->(config_path) do
  
  if Rails.env.development?
    require 'rb-fsevent'

    fsevent = FSEvent.new
    fsevent.watch config_path do
      
    end
    fsevent.run
  else
    
  Blobject.from_yaml(File.read(config_path))
  
end.('config/config.yaml')
