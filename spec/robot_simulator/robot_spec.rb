require 'spec_helper'

describe RobotSimulator::Robot do
  let(:location) { RobotSimulator::Location.new(2,2) }
  let(:top_border_location) { described_class.new(4,2) }
  subject { described_class.new(location, 'NORTH') }

  describe '.left' do
    it 'move the frontage to the left' do
      expect(subject.left).to be == 'WEST'
      expect(subject.left).to be == 'SOUTH'
      expect(subject.left).to be == 'EAST'
      expect(subject.left).to be == 'NORTH'
    end
  end

  describe '.right' do
    it 'move the frontage to the right' do
      expect(subject.right).to be == 'EAST'
      expect(subject.right).to be == 'SOUTH'
      expect(subject.right).to be == 'WEST'
      expect(subject.right).to be == 'NORTH'
    end
  end

  describe '.move' do
    it 'robot to the next north location' do
      expect(axis(subject.move)[:y]).to be > axis(location)[:y]
    end

    it 'robot to the next east location' do
      subject.right
      expect(axis(subject.move)[:x]).to be > axis(location)[:x]
    end

    it 'robot to the next south location' do
      subject.right
      subject.right
      expect(axis(subject.move)[:y]).to be < axis(location)[:y]
    end

    it 'robot to the next west location' do
      subject.left
      expect(axis(subject.move)[:x]).to be < axis(location)[:x]
    end
  end
end
