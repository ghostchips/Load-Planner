require_relative 'carrier'

module Carrier
  class Package < Container
    
    attr_reader :destination, :weight
    
    def initialize(opts = {})
      super
      @destination = opts[:destination]
    end
    
  end
end
