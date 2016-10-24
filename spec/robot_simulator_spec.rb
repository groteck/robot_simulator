require 'spec_helper'

describe RobotSimulator do
    let (:input) { StringIO.new() }
    let (:output) { StringIO.new() }
    subject { described_class.new(input, output) }

    before do
      allow_any_instance_of(described_class).to receive(:get_command)
    end

  describe '#place(command)' do
    it 'initialize the @robot' do
      subject.send(:place, 'PLACE 3 2 NORTH')
      expect(subject.last_message).to eq described_class::SUCCESS_MSG
    end

    it 'return error when the robot in placed out of the surface' do
      subject.send(:place, 'PLACE 3 9 NORTH')
      expect(subject.last_message).to include('The max number for locations')
    end
  end

  describe '#robot_command(command)' do
    before do
      subject.send(:place, 'PLACE 3 2 NORTH')
    end

    it 'send the command to the robot' do
      allow(subject.robot).to receive(:move).and_call_original
      subject.send(:robot_command, 'MOVE')
      expect(subject.last_message).to eq described_class::SUCCESS_MSG
    end

    it 'display message when the robot can not continue' do
      allow(subject.robot).to receive(:move).and_call_original
      subject.send(:robot_command, 'MOVE')
      subject.send(:robot_command, 'MOVE')
      expect(subject.last_message).to include('The robot is on the border')
    end
  end
end
