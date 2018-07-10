# frozen_string_literal: true
require_relative 'carrier'

module Carrier
  class Container

    attr_reader :properties, :content

    def initialize(opts={})
      @properties = Properties.new(
        opts[:length], opts[:width], opts[:height], opts[:weight], opts[:length]*opts[:width], opts[:length]*opts[:width]*opts[:height], opts[:capacity]
      )
      @content = Carrier::Content.new
    end

    def add_package(*new_packages)
      valid_packages = new_packages.select(&:is_package?)
      self.content = Carrier::Content.new(*content, *valid_packages)
    end

    def sort_by_origin(origin)
      content.sort_by_origin(origin, properties)
    end

    private
    attr_writer :content

    def is_package?
      self.class < Container
    end

    Properties = Struct.new(:length, :width, :height, :weight, :area, :volume, :capacity)

  end
end
