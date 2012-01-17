require_relative '../lib/blobject'

module ApiConfig
  def uri
    "http://#{hostname}#{path}.#{format}"
  end
end

MyApplication.config = Blobject.from_yaml(File.read('./config/config.yml'))
MyApplication.config.api.extend ApiConfig