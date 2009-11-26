require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ImgGravatar, "module methods" do
  subject { ImgGravatar }

  [:image_url, :link_gravatar].each do |method|
    it "should respond to #{method}" do
      subject.should respond_to(method)
    end
  end
end
