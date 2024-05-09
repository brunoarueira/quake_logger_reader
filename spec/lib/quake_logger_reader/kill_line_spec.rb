require 'spec_helper'

require_relative '../../../lib/quake_logger_reader'

RSpec.describe QuakeLoggerReader::KillLine do
  subject { described_class.new(line) }

  let(:line) do
    "  0:03 Kill: 6 2 18: Mal killed Oootsimo by MOD_TELEFRAG"
  end

  describe '#killer' do
    it 'returns the player who killed someone' do
      expect(subject.killer).to eq 'Mal'
    end
  end

  describe '#killer_world?' do
    context 'is TRUE' do
      it 'when the player who killed someone is <world>' do
        line = "  0:03 Kill: 6 2 18: <world> killed Oootsimo by MOD_TELEFRAG"

        subject = described_class.new(line)

        expect(subject.killer_world?).to be_truthy
      end
    end

    context 'is FALSE' do
      it 'when the player who killed someone is different from <world>' do
        expect(subject.killer_world?).to be_falsy
      end
    end
  end

  describe '#killed_player' do
    it 'returns the player killed' do
      expect(subject.killed_player).to eq 'Oootsimo'
    end
  end

  describe '#death_cause' do
    it 'returns the death cause from the kill' do
      expect(subject.death_cause).to eq 'MOD_TELEFRAG'
    end
  end
end
