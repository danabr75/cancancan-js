require 'cancancan'
require_relative 'cancancan_js/ability'

# module CanCanCanJS
#   # config src: http://lizabinante.com/blog/creating-a-configurable-ruby-gem/
#   class << self
#     attr_accessor :configuration
#   end

#   def self.configuration
#     @configuration ||= Configuration.new
#   end

#   def self.reset
#     @configuration = Configuration.new
#   end

#   def self.configure
#     yield(configuration)
#   end
# end