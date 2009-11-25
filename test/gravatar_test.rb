# Unit tests for ImgGravatar
require 'test/unit'
require 'img_gravatar'
require 'mocha'

class GravatarTest < Test::Unit::TestCase
  @@gravatar_host = "www.gravatar.com"
  @@base_url = "http://#{@@gravatar_host}/avatar"
  @@ref_mail = "iHaveAn@email.com"
  @@ref_hash = "3b3be63a4c2a439b013787725dfce802"
  
  def test_class_exists
    assert_not_nil ImgGravatar::Gravatar
  end
  
  def test_constructor
    gravatar = ImgGravatar::Gravatar.new("test@example.org", { :size => 20 })
    assert_equal "test@example.org", gravatar.email
    assert_equal 20, gravatar.options[:size]
  end
  
  def gravatar(email = @@ref_mail, options = {})
    ImgGravatar::Gravatar.new(email, options)
  end

  def test_url_generation_is_possible
    assert_respond_to gravatar, :image_url
  end

  def test_generating_a_basic_url
    assert_equal "#{@@base_url}\/#{@@ref_hash}", gravatar.image_url
  end
  
  def basic_url
    "#{@@base_url}\/#{@@ref_hash}"
  end

  def test_generating_a_url_with_size
    assert_equal "#{basic_url}?s=20", 
                 gravatar(@@ref_mail, :size => 20).image_url
  end

  def test_generating_a_url_with_default_image
    assert_equal "#{basic_url}?d=no_picture.png",
                 gravatar(@@ref_mail, :default_img => "no_picture.png").image_url
  end

  def test_generating_a_url_with_rating
    assert_equal "#{basic_url}?r=g",
                 gravatar(@@ref_mail, :rating => "g").image_url
  end

  def test_generating_a_url_with_everything
    assert_equal "#{basic_url}?d=no_picture.png&r=g&s=20",
                 gravatar(@@ref_mail, { 
                    :size => 20,
                    :default_img => "no_picture.png", 
                    :rating => "g"
                 }).image_url
  end

  def test_converting_to_a_string
    assert_equal gravatar.image_url, gravatar.to_s
  end

  def test_invalid_ratings
    assert_raises(ImgGravatar::InvalidRating) do
      gravatar(@@ref_mail, :rating => "invalid")
    end
  end

  def test_valid_ratings
    %w(g r x).each do |rating|
      assert_nothing_raised do
        gravatar(@@ref_mail, :rating => rating)
      end
    end
  end

  def test_invalid_sizes
    assert_raises(ImgGravatar::InvalidSize) do
      gravatar(@@ref_mail, :size => 9840384023)
    end
  end

  def test_generating_an_image_tag
    
  end
end
