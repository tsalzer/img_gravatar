require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ImgGravatar, "ActionView integration" do
  subject do
    class TestView < ActionView::Base ; end
    TestView.new
  end

  it "should respond to img_gravatar" do
    subject.should respond_to(:img_gravatar)
  end

  it "should produce the defined image URL" do
    # the reference data from http://en.gravatar.com/site/implement/url
    link_url = subject.img_gravatar(REF_MAIL)
    link_url.should =~ /^<img src="#{BASE_URL}\/#{REF_HASH}\" \/>/
  end

  it "should produce the minimal URL if no further arguments are given" do
    link_url = subject.img_gravatar(REF_MAIL)
    link_url.should =~ /^<img src="#{BASE_URL}\/[a-z0-9]{32}\" \/>/
  end

  ['g', 'r', 'x'].each do |rating|
    it "should generate a specific URL for rating #{rating} when requested" do
      link_url = subject.img_gravatar(REF_MAIL, {:rating => rating})
      link_url.should =~ /^<img src="#{BASE_URL}\/[a-z0-9]{32}\?r=#{rating}\" \/>/
    end
  end

  it "should generate specific size URLs for any dimension in 1..512" do
    (1..512).each do |size|
      link_url = subject.img_gravatar(REF_MAIL, {:size => size})
      link_url.should =~ /^<img src="#{BASE_URL}\/[a-z0-9]{32}\?s=#{size}\" size="#{size}" \/>/
    end
  end

  [0, -1 -10, -65535, -65536, 513, 640, 1024, 65535, 65536, 10000000].each do |size|
    it "should generate a default URL if the illegal size #{size} is given" do
      link_url = subject.img_gravatar(REF_MAIL, {:size => size})
      link_url.should =~ /^<img src="#{BASE_URL}\/[a-z0-9]{32}\" " \/>/
    end
  end

  it "should generate a URL pointing to a custom default URL if requested" do
    default_url = "http://example.com/images/example.jpg"
    link_url = subject.img_gravatar(REF_MAIL, {:default_url => default_url})
    link_url.should =~ /^<img src="#{BASE_URL}\/[a-z0-9]{32}\?d=#{default_url}\" \/>/
  end

  ['identicon', 'monsterid', 'wavatar'].each do |dflt|
    it "should use a URL for #{dflt} if requested" do
      link_url = subject.img_gravatar(REF_MAIL, {:default_url => dflt})
      link_url.should =~ /^<img src="#{BASE_URL}\/[a-z0-9]{32}\?d=#{dflt}\" \/>/
    end
  end

end
