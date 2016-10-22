class RobotSimulator
  # This class represents the robot,
  # and handle the robot instructions
  class Robot
    DIRECTIONS = %w(NORTH EAST SOUTH WEST)
    SIDES = { left: 1, right: 3 }

    def initialize(location, frontage)
      @location = location
      @frontage = frontage
      @frontage_indx = DIRECTIONS.find_index(frontage)
    end

    def move
      @location = @location.send(@frontage.downcase)
    end

    def report
      "position: #{@location.report}, frontage: #{@frontage}"
    end

    # Define left and right methods
    SIDES.each do |side_name, side_value|
      define_method(side_name) do
        @frontage = DIRECTIONS[@frontage_indx - side_value]
        @frontage_indx = DIRECTIONS.find_index(@frontage)
        @frontage
      end
    end
  end
end
