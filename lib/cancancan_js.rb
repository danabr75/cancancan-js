require 'cancancan'
require_relative 'cancancan_js/export'
require_relative 'cancancan_js/configuration'
require_relative 'cancancan_js/engine'
require_relative 'cancan/ability/front_end_rules_extensions'
require_relative 'cancan/ability/rules'

# config src: http://lizabinante.com/blog/creating-a-configurable-ruby-gem/
module CanCanCanJs
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end