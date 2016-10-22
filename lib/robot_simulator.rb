require "robot_simulator/version"
require "robot_simulator/location"
require "robot_simulator/robot"

class RobotSimulator
  def self.place(input)
    serialized_input = input.match(/PLACE\s(\d)\s(\d)\s(NORTH|EAST|SOUTH|WEST)/)

    if serialized_input.nil?
      puts 'Invalid format we expect PLACE Y X FRONTAGE'
      puts RobotSimulator.place(STDIN.gets)
    else
      axis_y, axis_x, frontage = serialized_input.captures
      @@robot = Robot.new(Location.new(axis_y.to_i, axis_x.to_i), frontage)
      puts "Nice your robot was placed into #{@@robot.report}"
    end
  end

  def self.robot_command(input)
    serialized_input = input.match(/(MOVE|LEFT|RIGHT|REPORT)/)

    if serialized_input.nil?
      puts 'Invalid command we expect MOVE, LEFT, RIGHT or REPORT'
      RobotSimulator.robot_operation(STDIN.gets)
    else
      operation = serialized_input.captures.first

      begin
        @@robot.send(operation.downcase)
        puts "Successful operation the new bot status is #{@@robot.report}"
      rescue Location::OutOfSurfaceException => e
        puts e.message
      end

      RobotSimulator.robot_operation(STDIN.gets)
    end
  end
end
