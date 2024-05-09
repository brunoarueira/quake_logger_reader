module QuakeLoggerReader
  class KillLine
    WORLD = "<world>"
    KILL_LINE_REGEX = /.*\d+: (?<killer>.*) killed (?<killed_player>.*) by (?<death_cause>.*)/.freeze

    def initialize(kill_line_content)
      @kill_line_content = kill_line_content
    end

    def killer
      @killer ||= parsed_line[:killer].strip
    end

    def killer_world?
      killer == WORLD
    end

    def killed_player
      parsed_line[:killed_player].strip
    end

    def death_cause
      parsed_line[:death_cause].strip
    end

    private

    def parsed_line
      @parsed_line ||= @kill_line_content.match(KILL_LINE_REGEX)
    end
  end
end
