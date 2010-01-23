Given /^user information (\w+) \<([\w\d\.]+\@[\w\d\.\-]+)\>$/ do |name, email|
  @username = name
  @usermail = email
end
Given /^email ([\w\d\.]+\@[\w\d\.\-]+)$/ do |email|
  @usermail = email
end
Given /^the String "([^\"]*)"$/ do |answer|
  @answer = answer
end


When /^I encode the email "([^\"]*)"$/ do |email|
  @answer = ImgGravatar.encode_email(email)
end
When /^I get the Gravatar URL for the user$/ do
  @answer = ImgGravatar.image_url(@usermail)
end
When /^I get the Gravatar image tag for the user$/ do
  @answer = ImgGravatar.link_gravatar(@usermail)
end


Then /^I should get a ([\w\d_:]+) object$/ do |classname|
  clss = eval(classname)
  @answer.should be_a clss
end

Then /^I should get the URL (.+)$/ do |urlstring|
  @answer.should be_a URI::HTTP
  @answer.to_s.should == urlstring
end

Then /^I should get the email hash ([\w\d]{32})$/ do |hashstring|
  @answer.should == hashstring
end

#Then /^I should not find "([^\"]*)" in it$/ do |arg1|
#  @answer.should_not =~ /#{arg1}/
#end

Then /^I should ((not )?)find "([^\"]*)" ((in any case )?)in it$/ do |ign1, should_or_not, expected, ign2, case_insensitive|
  should_or_not = should_or_not ? :should_not : :should
  answer = case_insensitive ? @answer.downcase : @answer
  expected = case_insensitive ? expected.downcase : expected

  answer.send(should_or_not) =~ /#{expected}/
end
