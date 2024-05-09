require 'spec_helper'

require_relative '../../../lib/quake_logger_reader'

RSpec.describe QuakeLoggerReader::Parser do
  subject { described_class.new('') }

  describe '#call' do
    it 'returns an empty array if there are any game' do
      allow(subject).to receive(:file_content).and_return([''])

      expect(subject.call).to eq([])
    end

    it 'returns an empty array if "InitGame:" is not in the lines' do
      lines = [
        "  0:03 Kill: 6 2 18: Mal killed Oootsimo by MOD_TELEFRAG",
        "  0:03 ClientBegin: 6",
        "  0:04 ClientUserinfoChanged: 7 n\Assasinu Credi\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\100\w\0\l\0\tt\0\tl\0",
        "  0:04 Kill: 7 6 18: Assasinu Credi killed Mal by MOD_TELEFRAG",
        "  0:04 ClientBegin: 7",
        "  0:04 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0",
        "  0:04 Kill: 3 7 18: Dono da Bola killed Assasinu Credi by MOD_TELEFRAG"
      ]

      allow(subject).to receive(:file_content).and_return(lines)

      expect(subject.call).to eq([])
    end

    it 'return at least one game if there are "InitGame:" when read the file' do
      lines = [
        "  0:03 Kill: 6 2 18: Mal killed Oootsimo by MOD_TELEFRAG",
        "  0:03 ClientBegin: 6",
        "  0:04 ClientUserinfoChanged: 7 n\Assasinu Credi\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\100\w\0\l\0\tt\0\tl\0",
        "  0:00 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\dmflags\\0\\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0",
        "  0:04 Kill: 7 6 18: Assasinu Credi killed Mal by MOD_TELEFRAG",
        "  0:04 ClientBegin: 7",
        "  0:04 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0",
        "  0:04 Kill: 3 7 18: Dono da Bola killed Assasinu Credi by MOD_TELEFRAG"
      ]

      allow(subject).to receive(:file_content).and_return(lines)

      game = QuakeLoggerReader::Game.new(0, lines[3..])

      last_game = subject.call.last

      expect(game.name).to eq(last_game.name)
    end
  end
end
