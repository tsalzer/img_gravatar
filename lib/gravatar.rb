require 'md5'
require 'uri'

# = Gravatar
# 
# Adds the +gravatar+ method to ActionViews.
#
# $Id$
module Gravatar #:nodoc:
  # gravatar.com base URL.
  # This is +http://www.gravatar.com/avatar.php+.
  mattr_reader :gravatar_base_url
  @@gravatar_base_url = 'http://www.gravatar.com/avatar.php'
  
  # default image URL. Default is +/img/no_gravatar.png+.
  mattr_accessor :default_img_url
  @@default_img_url = '/img/no_gravatar.png'
  
  # Default size of the image in pixel. Default is +40+.
  mattr_accessor :default_size
  @@default_size = 40
  
  # default rating.
  # Valid values are +G+, default is +G+.
  mattr_accessor :default_rating
  @@default_rating = 'G'
  
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
    def gravatar(email, opts={})
      # the defaults
      alt = nil
      default_img_url = Gravatar.default_img_url
      size = Gravatar.default_size
      rating = Gravatar.default_rating
      
      # now, load infos from options
      alt = opts[:alt] if opts[:alt]
      default_img_url = opts[:default_url] if opts[:default_url]
      size = opts[:size] if opts[:size]
      rating = opts[:rating] if opts[:rating]
      
      #uri = URI::HTTP.new(Gravatar.gravatar_base_url)
      uri = "%s?gravatar_id=%s&rating=%s&size=%s" % [Gravatar.gravatar_base_url,
        MD5.md5(email.strip),
        rating,
        size
        ]
      
      if alt then
        "<img src=\"%s\" alt=\"%s\" />" % [uri, alt]
      else
        "<img src=\"%s\" />" % uri
      end
    end
    
  end
end

# inject into ActionView.
#ActionView::Base.class_eval do
#  include Gravatar::Base
#end
ActionView::Base.send :include, Gravatar::InstanceMethods


