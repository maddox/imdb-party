# = Icebox : Caching for HTTParty
# 
# Cache responses in HTTParty models [http://github.com/jnunemaker/httparty]
# 
# === Usage
#
#   class Foo
#     include HTTParty
#     include HTTParty::Icebox
#     cache :store => 'file', :timeout => 600, :location => MY_APP_ROOT.join('tmp', 'cache')
#   end
#
# Modeled after Martyn Loughran's APICache [http://github.com/newbamboo/api_cache]
# and Ruby On Rails's caching [http://api.rubyonrails.org/classes/ActiveSupport/Cache.html]
#
# Author: Karel Minarik [www.karmi.cz]
# 
# === Notes
# 
# Thanks to Amit Chakradeo to point out objects have to be stored marhalled on FS
# Thanks to Marlin Forbes to point out query parameters have to be include in the cache key
# 
# 

require 'logger'
require 'fileutils'
require 'tmpdir'
require 'pathname'
require 'digest/md5'

module HTTParty #:nodoc:
  module Icebox

    module ClassMethods

      # Enable caching and set cache options
      # Returns memoized cache object
      #
      # Following options are available, default values are in []:
      #
      # +store+::       Storage mechanism for cached data (memory, filesystem, your own) [memory]
      # +timeout+::     Cache expiration in seconds [60]
      # +logger+::      Path to logfile or logger instance [STDOUT]
      # 
      # Any additional options are passed to the Cache constructor
      #
      # Usage:
      #
      #   # Enable caching in HTTParty, in memory, for 1 minute
      #   cache # Use default values
      #
      #   # Enable caching in HTTParty, on filesystem (/tmp), for 10 minutes
      #   cache :store => 'file', :timeout => 600, :location => '/tmp/'
      #
      #   # Use your own cache store (see AbstractStore class below)
      #   cache :store => 'memcached', :timeout => 600, :server => '192.168.1.1:1001'
      #
      def cache(options={})
        options[:store]   ||= 'memory'
        options[:timeout] ||= 60
        logger = options[:logger]
        @cache ||= Cache.new( options.delete(:store), options )
      end

    end

    # When included, extend class with +cache+ method
    # and redefine +get+ method to use cache
    # 
    def self.included(receiver) #:nodoc:
      receiver.extend ClassMethods
      receiver.class_eval do

        # Get reponse from network
        # TODO: Why alias :new :old is not working here? Returns NoMethodError
        # 
        def self.get_without_caching(path, options={})
          perform_request Net::HTTP::Get, path, options
        end

        # Get response from cache, if available
        # 
        def self.get_with_caching(path, options={})
          key = path.clone
          key << options[:query].to_s if defined? options[:query]
          
          if cache.exists?(key) and not cache.stale?(key)
            Cache.logger.debug "CACHE -- GET #{path}#{options[:query]}"
            return cache.get(key)
          else
            Cache.logger.debug "/!\\ NETWORK -- GET #{path}#{options[:query]}"
            response = get_without_caching(path, options)
            cache.set(key, response) if response.code == 200
            return response
          end
        end

        # Redefine original HTTParty +get+ method to use cache
        # 
        def self.get(path, options={})
          self.get_with_caching(path, options)
        end

      end
    end

    # === Cache container
    # 
    # Pass a store name ('memory', etc) to initializer
    # 
    class Cache
      attr_accessor :store

      def initialize(store, options={})
        self.class.logger = options[:logger]
        @store = self.class.lookup_store(store).new(options)
      end

      def get(key);            @store.get encode(key) unless stale?(key);        end
      def set(key, value);     @store.set encode(key), value;                    end
      def exists?(key);        @store.exists? encode(key);                       end
      def stale?(key);         @store.stale?  encode(key);                       end

      def self.logger; @logger || default_logger; end
      def self.default_logger; logger = ::Logger.new(STDERR); end

      # Pass a filename (String), IO object, Logger instance or +nil+ to silence the logger
      def self.logger=(device); @logger = device.kind_of?(::Logger) ? device : ::Logger.new(device); end

      private

      # Return store class based on passed name
      def self.lookup_store(name)
        store_name = "#{name.capitalize}Store"
        return Store::const_get(store_name)
      rescue NameError => e
        raise Store::StoreNotFound, "The cache store '#{store_name}' was not found. Did you loaded any such class?"
      end

      def encode(key); Digest::MD5.hexdigest(key); end
    end


    # === Cache stores
    # 
    module Store

      class StoreNotFound < StandardError; end #:nodoc:

      # ==== Abstract Store
      # Inherit your store from this class
      # *IMPORTANT*: Do not forget to call +super+ in your +initialize+ method!
      # 
      class AbstractStore
        def initialize(options={})
          raise ArgumentError, "You need to set the :timeout parameter" unless options[:timeout]
          @timeout = options[:timeout]
          message =  "Cache: Using #{self.class.to_s.split('::').last}"
          message << " in location: #{options[:location]}" if options[:location]
          message << " with timeout #{options[:timeout]} sec"
          Cache.logger.info message unless options[:logger].nil?
          return self
        end
        %w{set get exists? stale?}.each do |method_name|
          define_method(method_name) { raise NoMethodError, "Please implement method set in your store class" }
        end
      end

      # ===== Store objects in memory
      #
      Struct.new("TvdbResponse", :code, :body, :headers) { def to_s; self.body; end }
      class MemoryStore < AbstractStore
        def initialize(options={})
          super; @store = {}; self
        end
        def set(key, value)
          Cache.logger.info("Cache: set (#{key})")
          @store[key] = [Time.now, value]; true
        end
        def get(key)
          data = @store[key][1]
          Cache.logger.info("Cache: #{data.nil? ? "miss" : "hit"} (#{key})")
          data
        end
        def exists?(key)
          !@store[key].nil?
        end
        def stale?(key)
          return true unless exists?(key)
          Time.now - created(key) > @timeout
        end
        private
        def created(key)
          @store[key][0]
        end
      end

      # ===== Store objects on the filesystem
      # 
      class FileStore < AbstractStore
        def initialize(options={})
          super
          options[:location] ||= Dir::tmpdir
          @path = Pathname.new( options[:location] )
          FileUtils.mkdir_p( @path )
          self
        end
        def set(key, value)
          Cache.logger.info("Cache: set (#{key})")
          File.open( @path.join(key), 'w' ) { |file| Marshal.dump(value, file) }
          true
        end
        def get(key)
          data = Marshal.load(File.new(@path.join(key)))
          Cache.logger.info("Cache: #{data.nil? ? "miss" : "hit"} (#{key})")
          data
        end
        def exists?(key)
          File.exists?( @path.join(key) )
        end
        def stale?(key)
          return true unless exists?(key)
          Time.now - created(key) > @timeout
        end
        private
        def created(key)
          File.mtime( @path.join(key) )
        end
      end
    end

  end
end


# Major parts of this code are based on architecture of ApiCache.
# Copyright (c) 2008 Martyn Loughran
# 
# Other parts are inspired by the ActiveSupport::Cache in Ruby On Rails.
# Copyright (c) 2005-2009 David Heinemeier Hansson
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
