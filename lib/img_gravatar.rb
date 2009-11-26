DIGEST_INTERFACE = begin
  require 'md5'
  :ruby18
rescue LoadError
  require 'digest/md5'
  :ruby19
end

require 'uri'
require 'action_view'

# = ImgGravatar
# 
# Adds the +gravatar+ method to ActionViews.
module ImgGravatar #:nodoc:
  mattr_reader :gravatar_host
  @@gravatar_host = 'www.gravatar.com'
  # gravatar.com base URL.
  # This is +http://www.gravatar.com/avatar/+.
  mattr_reader :gravatar_base_url
  @@gravatar_base_url = "http://#{@@gravatar_host}/avatar"
  
  # default image URL. Default is +/img/no_gravatar.png+.
  mattr_accessor :default_img_url
  @@default_img_url = '/img/no_gravatar.png'
  
  mattr_reader :minimum_size
  @@minimum_size = 1
  mattr_reader :maximum_size
  @@maximum_size = 512
  
  # Default size of the image in pixel. Default is +80+.
  mattr_accessor :default_size
  @@default_size = 80
  
  # default rating.
  # Valid values are +g+, +r+, +x+, default is +g+.
  mattr_accessor :default_rating
  @@default_rating = 'g'
  
  ############################################################################
  # get the Gravatar image.
  # options:
  #   :alt          - the alternative text for this image (img attribute)
  #   :default_url  - the default URL for this gravatar
  #   :size         - the requested gravatar size (img attribute, gravatar-attribute)
  #   :rating       - the requested maximum rating
  def self.link_gravatar(email, opts={})
    # the defaults
    tag_options = {}
    tag_options[:alt] =opts[:alt]   if opts[:alt]
    tag_options[:size] =opts[:size] if opts[:size] && (opts[:size] >= 1 && opts[:size] <= 512)

    unless tag_options.empty?
      attributes = tag_options.collect {|key, value| "#{key}=\"#{value}\"" }.join(" ")
      "<img src=\"%s\" %s />" % [image_url(email, opts), attributes]
    else
      "<img src=\"%s\" />" % image_url(email, opts)
    end
  end

  ############################################################################
  # get the default Gravatar image.
  # options:
  #   :default_url  - the default URL for this gravatar
  #   :size         - the requested gravatar size
  #   :rating       - the requested maximum rating
  def self.image_url(email, opts={})
    appender = '?'
    
    # now, load infos from options
    default_img_url = check_default_opt(opts[:default_url])
    size = check_size_opt(opts[:size] )
    rating = check_rating_opt(opts[:rating])
    
    query = nil
    query = "s=%s" % size if size
    query = query ? "%s&r=%s" % [query, rating] : "r=%s" % rating if rating
    query = query ? "%s&d=%s" % [query, default_img_url] : "d=%s" % default_img_url if default_img_url
    
    query = URI.escape(query) if query
    
    #uri = URI::HTTP.new(Gravatar.gravatar_base_url)
    uri = URI::HTTP.build(:host => ImgGravatar.gravatar_host,
      :path => "/avatar/%s" % encode_md5(email),
      :query => query)
  end

  def self.encode_md5(email)
    value = email.downcase.strip
    case DIGEST_INTERFACE
      when :ruby18
        return MD5.md5(value)
      when :ruby19
        return Digest::MD5.hexdigest(value)
      else
        raise "unknown Ruby Digest interface."
    end
  end

  # Methods injected in all ActionView classes.
  module Base #:nodoc:
    def self.included(mod) #:nodoc:
      mod.extend(ClassMethods)
    end
  end
  
  # Methods injected in all ActionView classes.
  module ClassMethods #:nodoc:
    def self.extended(mod) #:nodoc#
      class_eval do
        include Gravatar::InstanceMethods
      end
    end
  end
  
  module InstanceMethods
    ############################################################################
    # get the Gravatar image.
    # See ImgGravatar.link_gravatar for options.
    def img_gravatar(email, opts={})
      return ::ImgGravatar.link_gravatar(email, opts)
    end
  end

  private
  
  def self.check_size_opt(size)
    return size if size and size >= ImgGravatar.minimum_size and size <= ImgGravatar.maximum_size
  end
  
  def self.check_rating_opt(rating)
    return rating if rating and ['g', 'r', 'x'].include?(rating)
  end
  
  def self.check_default_opt(dflt)
    return dflt if dflt
  end

end

# inject into ActionView.
ActionView::Base.send :include, ImgGravatar::InstanceMethods


