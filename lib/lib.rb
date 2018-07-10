# frozen_string_literal: true
require_relative 'loader'
require_relative 'carrier/carrier'

class Object
  alias_method :then, :yield_self
end