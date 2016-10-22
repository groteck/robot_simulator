$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'robot_simulator'
module Helpers
  def axis(location)
    {
      y: location.instance_variable_get(:@axis_y),
      x: location.instance_variable_get(:@axis_x)
    }
  end

  def location_axis(robot)
    axis(robot.instance_variable_get(:@location))
  end
end

RSpec.configure do |c|
    c.include Helpers
    c.mock_with :rspec
end
