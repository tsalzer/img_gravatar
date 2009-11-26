$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'img_gravatar'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

GRAVATAR_HOST = "www.gravatar.com"
BASE_URL = "http://#{GRAVATAR_HOST}/avatar"
REF_MAIL = "iHaveAn@email.com"
REF_HASH = "3b3be63a4c2a439b013787725dfce802"
BASIC_URL = "#{BASE_URL}/#{REF_HASH}"
