module QuakeLoggerReader
  module Report
    class Filter
      def self.call(selected_match, data)
        new(selected_match, data).call
      end

      def initialize(selected_match, data)
        @selected_match = selected_match
        @data = data
      end

      def call
        if @selected_match
          if @data.any? { |game| game.name == "game_#{@selected_match}" }
            @data.select { |game| game.name == "game_#{@selected_match}" }
          else
            raise ArgumentError, "The selected match #{@selected_match} could not be found"
          end
        else
          @data
        end
      end
    end
  end
end
