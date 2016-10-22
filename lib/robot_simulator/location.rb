class RobotSimulator
  # This class represents the location of
  # the robot and returns the posible movements.
  #
  # Raise an exception if a movement is not possble.
  class Location
    OutOfSurfaceException = Class.new(StandardError)
    MAX_AXIS_VAL = 4
    MIN_AXIS_VAL = 0

    def initialize(axis_y, axis_x)
      @axis_y = axis_y
      @axis_x = axis_x
    end

    def north
      out_of_surface(__method__) unless @axis_y < MAX_AXIS_VAL
      self.class.new(@axis_y + 1, @axis_x)
    end

    def east
      out_of_surface(__method__) unless @axis_x < MAX_AXIS_VAL
      self.class.new(@axis_y, @axis_x + 1)
    end

    def south
      out_of_surface(__method__) unless @axis_y > MIN_AXIS_VAL
      self.class.new(@axis_y - 1, @axis_x)
    end

    def west
      out_of_surface(__method__) unless @axis_x > MIN_AXIS_VAL
      self.class.new(@axis_y, @axis_x - 1)
    end

    def report
      "#{@axis_y}, #{@axis_x}"
    end

    private

    def out_of_surface(method_name)
      msg =
        'You are on the border of the surface, '\
        "You can not continue to the #{method_name}.\n"\
        'Please continue to a different location'

      raise OutOfSurfaceException.new(msg)
    end
  end
end
