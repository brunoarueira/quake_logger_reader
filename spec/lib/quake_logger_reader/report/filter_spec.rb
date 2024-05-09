require 'spec_helper'

require_relative '../../../../lib/quake_logger_reader'

RSpec.describe QuakeLoggerReader::Report::Filter do
  let(:game_1) { QuakeLoggerReader::Game.new(0, []) }
  let(:game_2) { QuakeLoggerReader::Game.new(1, []) }

  describe '#call' do
    it 'returns all the data if any match is passed' do
      subject = described_class.new(nil, [game_1, game_2])

      expect(subject.call).to eq([
        game_1,
        game_2
      ])
    end

    it 'filter the data to the passed match' do
      subject = described_class.new(1, [game_1, game_2])

      expect(subject.call).to eq([game_1])
    end

    it 'raises an error if the passed match does not found' do
      subject = described_class.new(3, [game_1, game_2])

      expect do
        subject.call
      end.to raise_error(ArgumentError, "The selected match 3 could not be found")
    end
  end
end
