module QuakeLoggerReader
  class Parser
    INIT_GAME_REGEX = /InitGame: /.freeze

    def self.call(filename)
      new(filename).call
    end

    def initialize(filename)
      @filename = filename
    end

    def call
      game_line_groups.each_with_index.inject([]) do |games, game_line_group_with_index|
        game_line_indexes, game_index = game_line_group_with_index

        start = game_line_indexes[0]
        final = (game_line_indexes[1] || file_content.length)

        games << Game.new(game_index, file_content[start..final])
      end
    end

    private

    def game_line_groups
      @game_line_groups ||= file_content
                            .each_index
                            .select { |index| file_content[index] =~ INIT_GAME_REGEX }
                            .each_slice(2)
                            .to_a
    end

    def file_content
      @file_content ||= File.readlines(@filename)
    end
  end
end
