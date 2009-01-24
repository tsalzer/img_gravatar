# Unit tests for ImgGravatar
require 'test/unit'
require 'img_gravatar'

class ModuleGravatarTest < Test::Unit::TestCase
  @@gravatar_host = "www.gravatar.com"
  @@base_url = "http://#{@@gravatar_host}/avatar"
  @@ref_mail = "iHaveAn@email.com"
  @@ref_hash = "3b3be63a4c2a439b013787725dfce802"
  
  def test_module_functions
    assert(ImgGravatar.respond_to?('image_url'), 'Module ImgGravatar does not respond to image_url')
    assert(ImgGravatar.respond_to?('link_gravatar'), 'Module ImgGravatar does not respond to link_grevatar')
  end
  
  def test_reference_data
    # the reference data from http://en.gravatar.com/site/implement/url
    link_url = ImgGravatar.link_gravatar(@@ref_mail)
    assert_match(/^<img src="#{@@base_url}\/#{@@ref_hash}\" \/>/, link_url)
    #assert_match(/^<img src="http:\/\/www\.gravatar\.com\/avatar\/#{ref_hash}\" \/>/, link_url)
  end
end