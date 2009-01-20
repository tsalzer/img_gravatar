# Unit tests for ImgGravatar
require 'test/unit'
require 'img_gravatar'

class TestView < ActionView::Base
end

class ImgGravatarTest < Test::Unit::TestCase
  @@gravatar_host = "www.gravatar.com"
  @@base_url = "http://#{@@gravatar_host}/avatar"
  @@ref_mail = "iHaveAn@email.com"
  @@ref_hash = "3b3be63a4c2a439b013787725dfce802"
  
    
  def test_actionview_integration
    myview = TestView.new
    assert myview.respond_to?('img_gravatar'), "integration into ActionView failed"
  end
  
  def test_reference_data
    myview = TestView.new
    # the reference data from http://en.gravatar.com/site/implement/url
    link_url = myview.img_gravatar(@@ref_mail)
    assert_match(/^<img src="#{@@base_url}\/#{@@ref_hash}\" \/>/, link_url)
    #assert_match(/^<img src="http:\/\/www\.gravatar\.com\/avatar\/#{ref_hash}\" \/>/, link_url)
  end
  
  def test_actionview_url
    myview = TestView.new
    link_url = myview.img_gravatar(@@ref_mail)
    assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\" \/>/, link_url)
  end
  
  def test_defaults
    myview = TestView.new
    link_url = myview.img_gravatar(@@ref_mail)
    assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\" \/>/, link_url)
  end
  
  def test_actionview_ratings
    myview = TestView.new
    ['g', 'r', 'x'].each do |rating|
      link_url = myview.img_gravatar(@@ref_mail, {:rating => rating})
      assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\?r=#{rating}\" \/>/, link_url)
    end
  end
  
  def test_actionview_size
    myview = TestView.new
    (1..512).each do |size|
      link_url = myview.img_gravatar(@@ref_mail, {:size => size})
      assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\?s=#{size}\" \/>/, link_url)
    end
  end
  
  def test_illegal_small_sizes
    myview = TestView.new
    (-10..0).each do |size|
      link_url = myview.img_gravatar(@@ref_mail, {:size => size})
      assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\" \/>/, link_url)
    end
  end
  
  def test_illegal_large_sizes
    myview = TestView.new
    (513..10000).each do |size|
      link_url = myview.img_gravatar(@@ref_mail, {:size => size})
      assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\" \/>/, link_url)
    end
  end
  
  def test_default_image_encoding
    myview = TestView.new
    unencoded = "http://example.com/images/example.jpg"
    encoded = 'http%3A%2F%2Fexample.com%2Fimages%2Fexample.jpg'
    link_url = myview.img_gravatar(@@ref_mail, {:default_url => unencoded})
    assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\?d=#{encoded}\" \/>/, link_url)
  end
  
  def test_default_image_specials
    myview = TestView.new
    ['identicon', 'monsterid', 'wavatar'].each do |dflt|
      link_url = myview.img_gravatar(@@ref_mail, {:default_url => dflt})
      assert_match(/^<img src="#{@@base_url}\/[a-z0-9]{32}\?d=#{dflt}\" \/>/, link_url)
    end
  end
  
end
