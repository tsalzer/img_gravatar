require 'md5'
require 'uri'
require 'action_view'

# = Gravatar
# 
# Adds the +gravatar+ method to ActionViews.
#
# $Id$
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
    # get the default Gravatar image.
    # options:
    #   :alt          - the alternative text for this image
    #   :default_url  - the default URL for this gravatar
    #   :size         - the requested gravatar size
    #   :rating       - the requested maximum rating
    def img_gravatar(email, opts={})
      # the defaults
      alt = nil
      appender = '?'
      
      # now, load infos from options
      alt = opts[:alt] if opts[:alt]
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
        :path => "/avatar/%s" % MD5.md5(email.downcase.strip),
        :query => query)

      if alt then
        "<img src=\"%s\" alt=\"%s\" />" % [uri, alt]
      else
        "<img src=\"%s\" />" % uri
      end
      
    end

    
    private
    
    def check_size_opt(size)
      if size and size >= ImgGravatar.minimum_size and size <= ImgGravatar.maximum_size
        return size
      end
    end
    
    def check_rating_opt(rating)
      if rating and ['g', 'r', 'x'].include?(rating)
        return rating
      end
    end
    
    def check_default_opt(dflt)
      if dflt
        return dflt
      end
    end
  end
end

# inject into ActionView.
#ActionView::Base.class_eval do
#  include Gravatar::Base
#end
ActionView::Base.send :include, ImgGravatar::InstanceMethods


