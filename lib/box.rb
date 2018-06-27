require_relative 'container'

class Box < Container

  attr_reader :receiver_address, :sender_address

  def initialize(opts = {})
    super
    @receiver_address = opts[:receiver_address]
    @sender_address = opts[:sender_address]
  end

end