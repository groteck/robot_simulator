require 'spec_helper'

describe RobotSimulator do
  describe 'self.place' do
    before do
      allow(STDIN).to receive(:gets) { 'PLACE 3 2 NORTH' }
    end

    it 'initialize the @@robot var' do
      msg = "Nice your robot was placed into position: 3, 2, frontage: NORTH\n"

      expect{ described_class.place('PLACE 3 2 NORTH') }
        .to output(msg).to_stdout
    end

    it 'display format error message if the input has a wrong format' do
      msg = "Invalid format, expected format is: PLACE Y X FRONTAGE\n"\
        "Nice your robot was placed into position: 3, 2, frontage: NORTH\n"

      expect{ described_class.place('EPLACE 3 2 NORTH') }
        .to output(msg).to_stdout
      expect{ described_class.place('PLACE 3 2 NORTHE') }
        .to output(msg).to_stdout
      expect{ described_class.place('sdfgh') }
        .to output(msg).to_stdout
    end

    it 'display wrong axis value error if the axis are < 0 or > 4' do
      msg = "The max number for locations is 4. "\
        "The min number for locations is 0\n"\
        "Please place the robot into this values\n"\
        "Nice your robot was placed into position: 3, 2, frontage: NORTH\n"

      expect{ described_class.place('PLACE 3 6 NORTH') }
        .to output(msg).to_stdout
      expect{ described_class.place('PLACE 6 6 NORTH') }
        .to output(msg).to_stdout
      expect{ described_class.place('PLACE 6 3 NORTH') }
        .to output(msg).to_stdout
    end
  end

  describe 'self.command_msg' do
    before do
      $stdout = StringIO.new
      described_class.place('PLACE 3 2 NORTH')
    end

    after(:all) do
      $stdout = STDOUT
    end

    it 'send the command to the robot' do
      msg = 'Successful command the bot status is position:'\
        ' 4, 2, frontage: NORTH'

      expect(described_class.send(:command_msg, 'MOVE'.match(/^(MOVE)$/)))
        .to be == msg
    end

    it 'the report command display a custom message' do
      msg = 'position: 3, 2, frontage: NORTH'

      expect(described_class.send(:command_msg, 'REPORT'.match(/^(REPORT)$/)))
        .to be == msg
    end

    it 'returns invalid format message with invalid commands' do
      msg = 'Invalid command we expect MOVE, LEFT, RIGHT or REPORT'

      expect(described_class.send(:command_msg, nil))
        .to be == msg
    end

    it 'returns border message when the bot is on the border' do
      msg = 'You are on the border of the surface, '\
        "You can not continue to the NORTH.\n"\
        'Please continue to a different direction,'\
        ' available directions are: '\
        "EAST, SOUTH, WEST"

      described_class.send(:command_msg, 'MOVE'.match(/^(MOVE)$/))
      expect(described_class.send(:command_msg, 'MOVE'.match(/^(MOVE)$/)))
        .to be == msg
    end
  end
end
