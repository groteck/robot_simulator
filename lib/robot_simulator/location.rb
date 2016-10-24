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
      validate_axis!
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

    def validate_axis!
      unless @axis_y <= MAX_AXIS_VAL &&
        @axis_y >= MIN_AXIS_VAL &&
        @axis_x <= MAX_AXIS_VAL &&
        @axis_x >= MIN_AXIS_VAL

        out_of_surface(__method__)
      end
    end

    def out_of_surface(method_name)
      msg =
        if method_name.to_s == 'validate_axis!'
          "The max number for locations is #{MAX_AXIS_VAL}. "\
            "The min number for locations is #{MIN_AXIS_VAL}\n"\
            'Please place the robot into this values'
        else
          'The robot is on the border of the surface, '\
            "The robot can not continue to the #{method_name.upcase}.\n"\
            'Please continue to a different direction,'\
            " available directions are: "\
            "#{(Robot::DIRECTIONS - [method_name.to_s.upcase]).join(', ')}"
        end

      raise OutOfSurfaceException.new(msg)
    end
  end
end
