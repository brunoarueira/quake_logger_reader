require 'spec_helper'

require_relative '../../../lib/quake_logger_reader'

RSpec.describe QuakeLoggerReader::Game do
  let(:template_lines) do
    [
      "  0:03 Kill: 6 2 18: Mal killed Oootsimo by MOD_TELEFRAG",
      "  0:03 ClientBegin: 6",
      "  0:04 ClientUserinfoChanged: 7 n\Assasinu Credi\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\100\w\0\l\0\tt\0\tl\0",
      "  0:04 Kill: 7 6 18: Assasinu Credi killed Mal by MOD_TELEFRAG",
      "  0:04 ClientBegin: 7",
      "  0:04 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0",
      "  0:04 Kill: 3 7 18: Dono da Bola killed Assasinu Credi by MOD_TELEFRAG"
    ]
  end

  describe '#death_causes' do
    it 'returns nothing if does not have any lines' do
      subject = described_class.new(1, [])

      expect(subject.death_causes).to eq({ "game_2" => { kills_by_means: {} } })
    end

    it 'returns death causes from the match if does have kill lines' do
      subject = described_class.new(1, template_lines)

      expect(subject.death_causes).to eq({
        "game_2" => { kills_by_means: { "MOD_TELEFRAG" => 3 } }
      })
    end
  end

  describe '#to_h' do
    it 'returns only the name with total_kills, players and kills empty' do
      subject = described_class.new(1, [])

      expect(subject.to_h).to eq({
        "game_2" => {
          total_kills: 0,
          players: [],
          kills: {}
        }
      })
    end

    it 'returns the name with total_kills, players and kills parsed' do
      subject = described_class.new(1, template_lines)

      expect(subject.to_h).to eq({
        "game_2" => {
          total_kills: 3,
          players: ["Dono da Bola", "Assasinu Credi", "Mal"],
          kills: {
            "Assasinu Credi" => 1,
            "Dono da Bola" => 1,
            "Mal" => 1
          }
        }
      })
    end
  end
end
