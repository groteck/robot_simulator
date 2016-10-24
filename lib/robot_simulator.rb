require "robot_simulator/version"
require "robot_simulator/location"
require "robot_simulator/robot"

# The class RobotSimulator has the controll of the io input and output
class RobotSimulator
  PLACE_REGEXP = /^PLACE\s(\d)\s(\d)\s(NORTH|EAST|SOUTH|WEST)$/
  ORDER_REGEXP = /^(MOVE|LEFT|RIGHT|REPORT)$/
  INITIAL_MSG = "Wellcome to the Robot Simulator "\
    "v#{RobotSimulator::VERSION}\n"\
    "Pease place the bot into the surface with the order PLACE\n"\
    "  Example: PLACE 3 2 NORTH\n"\
    "  place a bot on the position 3,2 and the frontage to the north"
  SUCCESS_MSG = 'Successful command!'

  attr_reader :input, :output, :robot, :last_message

  def initialize(input, output)
    @input = input
    @output = output
    wellcome_message
    get_command
  end

  private

  def wellcome_message
    output.puts INITIAL_MSG
  end

  def get_command
    output.puts last_message unless last_message.nil?
    command = input.gets

    if command =~ PLACE_REGEXP
      place(command)
    elsif command =~ ORDER_REGEXP
      robot_command(command)
    else
      unexpected_command(command)
    end

    get_command
  end

  def place(command)
    serialized_input = command.match(PLACE_REGEXP)

    begin
      axis_y, axis_x, frontage = serialized_input.captures
      @robot = Robot.new(Location.new(axis_y.to_i, axis_x.to_i), frontage)
      @last_message = SUCCESS_MSG
    rescue Location::OutOfSurfaceException => e
      @last_message = e.message
    end
  end

  def unexpected_command(command)
    @last_message =
      "Unexpected command: #{command.delete("\n")}, "\
      "expected commands are: #{available_commands}"
  end

  def available_commands
    if robot.nil?
      'PLACE Y X Z'
    else
      'PLACE Y X Z, MOVE, LEFT, RIGHT or REPORT'
    end
  end

  def robot_command(command)
    serialized_input = command.match(ORDER_REGEXP).captures.first

    begin
      @last_message = robot.send(serialized_input.downcase)
      @last_message = SUCCESS_MSG if serialized_input != 'REPORT'
    rescue Location::OutOfSurfaceException => e
      @last_message = e.message
    end
  end
end
