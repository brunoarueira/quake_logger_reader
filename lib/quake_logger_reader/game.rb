module QuakeLoggerReader
  class Game
    IDENTIFIER_KILL_LINE_REGEX = /Kill: /.freeze

    attr_reader :name

    def initialize(index, game_lines)
      @game_lines = game_lines

      @name = "game_#{index + 1}"
    end

    def death_causes
      kills_by_means =
        kill_lines
        .map(&:death_cause)
        .group_by { |death_cause| death_cause }
        .map { |key, values| [key, values.length] }
        .sort_by { |item| item[1] }
        .reverse
        .to_h

      {
        name => { kills_by_means: kills_by_means }
      }
    end

    def to_h
      {
        name => {
          total_kills: kill_lines.length,
          players: kills.keys.map { |killer| players.find { |p| p == killer } || killer },
          kills: kills
        }
      }
    end

    private

    def players
      killers = kill_lines
                .reject(&:killer_world?)
                .map(&:killer)

      killed_players = kill_lines.map(&:killed_player)

      [killers + killed_players].flatten.uniq
    end

    def kills
      kill_lines
        .reject(&:killer_world?)
        .group_by { |line| line.killer }
        .map do |group|
          points =
            kill_lines.count { |line| line.killer == group[0] } -
            kill_lines.count { |line| line.killer_world? && line.killed_player == group[0] }

          [group[0], points]
        end
        .sort_by { |item| item[1] }
        .reverse
        .to_h
    end

    def kill_lines
      @kill_lines ||=
        @game_lines
        .select { |line| line =~ IDENTIFIER_KILL_LINE_REGEX }
        .map { |line| KillLine.new(line) }
    end
  end
end
