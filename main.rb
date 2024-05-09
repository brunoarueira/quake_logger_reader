require 'optparse'
require 'json'
require 'pathname'

require_relative './lib/quake_logger_reader'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: main.rb FILE [options]"

  opts.on('FILE')

  opts.on(
    '-m',
    '--match [MATCH]',
    Integer,
    'Prints a report of each match and their ranking, can filter too with specific match'
  )

  opts.on(
    '-d',
    '--death-cause [MATCH]',
    Integer,
    "Prints a report of death causes' ranking"
  )

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!(into: options)

if options.empty?
  puts 'Usage: main.rb -h to see the other options'
end

file = ARGV[0] || 'spec/fixtures/qgames.log'

data = QuakeLoggerReader::Parser.call(Pathname.new(file))

if options.key?(:match)
  begin
    matches = QuakeLoggerReader::Report::Filter.call(options[:match], data)

    puts JSON.dump(matches.map(&:to_h))
  rescue ArgumentError => e
    puts "ERROR: #{e.message}"
  end
elsif options.key?(:"death-cause")
  begin
    death_causes = QuakeLoggerReader::Report::Filter.call(options[:"death-cause"], data)

    death_causes = death_causes.map(&:death_causes)

    ranking_death_causes = death_causes.reduce({}) do |sums, death_cause|
      sums.merge(death_cause) { |_, a, b| a + b }
    end

    puts JSON.dump(ranking_death_causes)
  rescue ArgumentError => e
    puts "ERROR: #{e.message}"
  end
end
