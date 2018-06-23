require_relative 'box'

class Container
  
  attr_reader :length, :width, :height, :floor_area, :total_volume, :boxes
  
  def initialize(opts={})
    raise unless [opts[:length], opts[:width], opts[:height]].all? { |dim| dim&.is_a?(Integer) }
    @length = [opts[:length], opts[:width]].max
    @width = [opts[:length], opts[:width]].min
    @height = opts[:height]
    @floor_area = @length * @width
    @total_volume = @floor_area * @height
    @boxes = []
  end
  
  def add_box(*new_boxes)
    container_boxes = new_boxes.select(&:is_box?)
    self.boxes = [*boxes, *container_boxes]
  end
  
  def sort_boxes_by(attribute_call)
    return unless boxes.all? { |box| box.class.method_defined?(attribute_call.to_sym)  }
    boxes.sort_by(&attribute_call.to_sym)
  end
  
  def is_box?
    self.class < Container
  end
  
  private
  attr_writer :boxes
  
end
