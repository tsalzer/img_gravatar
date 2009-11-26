require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Unit tests for ImgGravatar
#require 'test/unit'
require 'img_gravatar'
#require 'mocha'

describe ImgGravatar::Gravatar, "constructor" do
  subject { ImgGravatar::Gravatar }

  it "should create an instance with email and size attribute" do
    gravatar = subject.new(REF_MAIL, { :size => 20 })
    gravatar.email.should == REF_MAIL
    gravatar.options[:size].should == 20
  end
end

describe ImgGravatar::Gravatar, "basic functionality" do
  subject { ImgGravatar::Gravatar.new(REF_MAIL, {}) }

  it "should respond to :image_url" do
    subject.should respond_to :image_url
  end

  it "should create a valid basic URL" do
    subject.image_url.should == BASIC_URL
  end

  it "should return its image_url if converted to string" do
    subject.image_url.should == subject.to_s
  end
end

describe ImgGravatar::Gravatar, "URL with parameters" do
  subject { ImgGravatar::Gravatar }

  it "should generate the right URL for a given size" do
    subject.new(REF_MAIL, :size => 20).image_url.should == "#{BASIC_URL}?s=20"
  end

  it "should generate the right URL for a default image" do
    subject.new(REF_MAIL, :default_img => "no_picture.png").image_url.should == "#{BASIC_URL}?d=no_picture.png"
  end

  it "should generate the right URL for a rating" do
    subject.new(REF_MAIL, :rating => "g").image_url.should == "#{BASIC_URL}?r=g"
  end

  it "should generate the right URL when all parameters are set" do
    pending "order of hash keys is indeterminated in Ruby 1.8" do
      subject.new(REF_MAIL,
                  {:default_img => "no_picture.png",
                   :rating => "g",
                   :size => 20}).image_url.should == "#{BASIC_URL}?d=no_picture.png&r=g&s=20"
    end
  end
end

describe ImgGravatar::Gravatar, "parameter validation" do
  subject { ImgGravatar::Gravatar }

  it "should raise an error on invalid ratings" do
    lambda{subject.new(REF_MAIL, :rating => "invalide")}.should raise_error(ImgGravatar::InvalidRating)
  end

  %w(g r x).each do |rating|
    it "should not raise an error for rating #{rating}" do
      lambda{subject.new(REF_MAIL, :rating => rating)}.should_not raise_error(ImgGravatar::InvalidRating)
    end
  end

  [9840384023, 0, -1, 513].each do |size|
    it "should raise an error for invalid size #{size}" do
      lambda{subject.new(REF_MAIL, :size=> size)}.should raise_error(ImgGravatar::InvalidSize)
    end
  end

  [1, 20, 40, 128, 512].each do |size|
    it "should not raise an error for valid size #{size}" do
      lambda{subject.new(REF_MAIL, :size=> size)}.should_not raise_error(ImgGravatar::InvalidSize)
    end
  end

  it "should generate a valid image tag"
end
