MyApplication::Config = ->(config_path) do
  
  if Rails.env.development?
    require 'rb-fsevent'

    fsevent = FSEvent.new
    fsevent.watch config_path do
      suppress_warnings do
        MyApplication::Config = Blobject.read(config_path)
      end
    end
    fsevent.run
  else
    
  MyApplication::Config = Blobject.read(config_path)

end.('config/config.yml')
