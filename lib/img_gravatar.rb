require 'md5'
require 'uri'
require 'action_view'

# = Gravatar
# 
# Adds the +gravatar+ method to ActionViews.
#
# $Id$
module ImgGravatar #:nodoc:
  class InvalidRating < RuntimeError; end
  class InvalidSize < RuntimeError; end
  
  class Gravatar
    attr_accessor :email
    attr_accessor :options

    def initialize(email, options = {})
      self.email = email
      self.options = options

      validate_options
    end

    def image_url
      URI::HTTP.build(:host => ImgGravatar.gravatar_host,
                      :path => image_path,
                      :query => query_string).to_s
    end
    alias :to_s :image_url
    
    def image_tag
      
    end

    protected
      def validate_options
        %w(rating size).each { |option| send("validate_#{option}") }
      end
      
      def validate_rating
        unless options[:rating].nil? || %w(g r x).include?(options[:rating])
          raise InvalidRating.new
        end
      end

      def validate_size
        return if options[:size].nil?

        size = options[:size]
        if size < ImgGravatar.minimum_size || size > ImgGravatar.maximum_size
          raise InvalidSize.new
        end
      end

      def image_path
        "/avatar/%s" % MD5.md5(email.downcase.strip)
      end

      def query_string
        query_options = {}
        { "s" => :size,
          "d" => :default_img,
          "r" => :rating }.each do |key, value|
          query_options[key] = options[value] if options[value]
        end
        
        if query_options.size > 0
          query_options.collect { |key, value| "#{key}=#{value}" }.join("&")
        end
      end
  end

  include ActionView::Helpers::AssetTagHelper
  
  mattr_reader :gravatar_host
  @@gravatar_host = 'www.gravatar.com'
  # gravatar.com base URL.
  # This is +http://www.gravatar.com/avatar/+.
  mattr_reader :gravatar_base_url
  @@gravatar_base_url = "http://#{@@gravatar_host}/avatar"
  
  mattr_reader :minimum_size
  @@minimum_size = 1
  mattr_reader :maximum_size
  @@maximum_size = 512
  
  # default rating.
  # Valid values are +g+, +r+, +x+, default is +g+.
  mattr_accessor :default_rating
  @@default_rating = 'g'
  
  ############################################################################
  # get the Gravatar image.
  # options:
  #   :alt          - the alternative text for this image
  #   :default_url  - the default URL for this gravatar
  #   :size         - the requested gravatar size
  #   :rating       - the requested maximum rating
  def self.link_gravatar(email, opts={})
    # the defaults
    tag_options = {}
    tag_options[:alt] = opts[:alt] if opts[:alt]
    tag_options[:size] = opts[:size] if opts[:size]
    
    image_tag(image_url(email, opts), tag_options)
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
end

# inject into ActionView.
ActionView::Base.send :include, ImgGravatar::InstanceMethods


