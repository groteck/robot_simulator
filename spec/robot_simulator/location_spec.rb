require 'spec_helper'

describe RobotSimulator::Location do
  let(:center_location) { described_class.new(2,2) }
  let(:top_border_location) { described_class.new(4,2) }
  let(:right_border_location) { described_class.new(2,4) }
  let(:bottom_border_location) { described_class.new(0,2) }
  let(:left_border_location) { described_class.new(2,0) }

  describe '.north' do
    it 'retunrs the next location in north position' do
      expect(axis(center_location)[:y]).to be < axis(center_location.north)[:y]
    end

    it 'raise an exception if the next north location is out of the surface' do
      expect{top_border_location.north}
      .to raise_error(RobotSimulator::Location::OutOfSurfaceException)
    end
  end

  describe '.east' do
    it 'retunrs the next location in east position' do
      expect(axis(center_location)[:x]).to be < axis(center_location.east)[:x]
    end

    it 'raise an exception if the next east location is out of the surface' do
      expect{right_border_location.east}
      .to raise_error(RobotSimulator::Location::OutOfSurfaceException)
    end
  end

  describe '.south' do
    it 'retunrs the next location in south position' do
      expect(axis(center_location)[:y]).to be > axis(center_location.south)[:y]
    end

    it 'raise an exception if the next south location is out of the surface' do
      expect{bottom_border_location.south}
      .to raise_error(RobotSimulator::Location::OutOfSurfaceException)
    end
  end

  describe '.west' do
    it 'retunrs the next location in west position' do
      expect(axis(center_location)[:x]).to be > axis(center_location.west)[:x]
    end

    it 'raise an exception if the next west location is out of the surface' do
      expect{left_border_location.west}
      .to raise_error(RobotSimulator::Location::OutOfSurfaceException)
    end
  end
end
