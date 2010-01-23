require 'digest/md5'
require 'uri'

# = ImgGravatar
# 
# Adds the +img_gravatar+ method to ActionViews. 
module ImgGravatar
  # Host to use for Gravatars. This is always +www.gravatar.com+.
  GRAVATAR_HOST = 'www.gravatar.com'
  # gravatar.com base-URL. This is +http://www.gravatar.com/avatar/+.
  GRAVATAR_BASE_URL = "http://#{GRAVATAR_HOST}/avatar"
  # default image URL. Default is +/img/no_gravatar.png+.
  DEFAULT_IMG_URL = '/img/no_gravatar.png'
  # Minimum possible size for a Gravatar. This is 1 pixel as specified by gravatar.com.
  MINIMUM_SIZE = 1
  # Maxmum possible size for a Gravatar. This is 512 pixel as specified by gravatar.com.
  MAXIMUM_SIZE = 512
  # Default size for a Gravatar. This is 80 pixel as specified by gravatar.com.
  DEFAULT_SIZE = 80
  # Possible ratings.
  # TODO: Check gravatar.com for current ratings.
  RATINGS = ['g', 'r', 'x']
  # Default rating. This is the first possible Rating.
  DEFAULT_RATING = RATINGS.first

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
    tag_options[:alt]  =opts[:alt]  if opts[:alt]
    tag_options[:size] =opts[:size] if opts[:size] && (opts[:size] >= MINIMUM_SIZE && opts[:size] <= MAXIMUM_SIZE)

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
    size = check_size_opt(opts[:size])
    rating = check_rating_opt(opts[:rating])
    
    query = nil
    query = "s=%s" % size if size
    query = query ? "%s&r=%s" % [query, rating] : "r=%s" % rating if rating
    query = query ? "%s&d=%s" % [query, default_img_url] : "d=%s" % default_img_url if default_img_url
    
    query = URI.escape(query) if query
    
    URI::HTTP.build(:host => GRAVATAR_HOST,
      :path => "/avatar/%s" % encode_email(email),
      :query => query)
  end

  def self.encode_email(email)
    Digest::MD5.hexdigest(email.downcase.strip)
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

  # Methods available in ActionView.
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
    size and size >= MINIMUM_SIZE and size <= MAXIMUM_SIZE ? size : nil
  end
  
  def self.check_rating_opt(rating)
   rating and RATINGS.include?(rating) ? rating : nil
  end
  
  def self.check_default_opt(dflt)
    #TODO: what do we need this for?
    dflt if dflt
  end

end

# inject into ActionView.
begin
  require 'action_view'
  ActionView::Base.send :include, ImgGravatar::InstanceMethods
rescue LoadError
  # So we have not ActionView. That's ok, if we just need the ImgGravatar functionality.
end
