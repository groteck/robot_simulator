require "robot_simulator/version"
require "robot_simulator/location"
require "robot_simulator/robot"

# The class RobotSimulator has the controll of the io input and output
class RobotSimulator
  # This method initialize the robot and handle error messages
  def self.place(input)
    serialized_input =
      input.match(/^PLACE\s(\d)\s(\d)\s(NORTH|EAST|SOUTH|WEST)$/)

    if serialized_input.nil?
      puts_and_call('Invalid format, expected format is: PLACE Y X FRONTAGE',
                    __method__)
    else
      begin
        axis_y, axis_x, frontage = serialized_input.captures
        @@robot = Robot.new(Location.new(axis_y.to_i, axis_x.to_i), frontage)
        puts "Nice your robot was placed into #{@@robot.report}"
      rescue Location::OutOfSurfaceException => e
        puts_and_call(e.message, __method__)
      end
    end
  end

  # This method handle the robot commands and
  # display the errors if some command is not possible or has a wrong format
  def self.robot_command(input)
    serialized_input = input.match(/^(MOVE|LEFT|RIGHT|REPORT)$/)
    msg = command_msg(serialized_input)
    puts_and_call(msg, __method__)
  end


  def self.puts_and_call(message, method)
    puts message
    self.send(method, STDIN.gets)
  end

  private_class_method :puts_and_call

  def self.command_msg(serialized_input)
    if serialized_input.nil?
      'Invalid command we expect MOVE, LEFT, RIGHT or REPORT'
    else
      command = serialized_input.captures.first

      begin
        if command != 'REPORT'
          @@robot.send(command.downcase)
          "Successful command the bot status is #{@@robot.report}"
        else
          @@robot.report
        end
      rescue Location::OutOfSurfaceException => e
        e.message
      end
    end
  end

  private_class_method :command_msg
end
