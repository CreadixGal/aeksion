# lib/tasks/convert_to_csv.rake
require 'csv'

namespace :db do
  desc 'Convert plain text tables to CSV'
  task convert_to_csv: :environment do
    source_directory = Rails.root.join('lib/tasks/database/tables_plain_data')
    output_directory = Rails.root.join('lib/tasks/database/converted_csv')
    Dir.mkdir(output_directory) unless Dir.exist?(output_directory)

    puts '🚀 Starting conversion process...'
    Dir.glob(File.join(source_directory, '*.txt')).each do |file|
      convert_file_to_csv(file, output_directory)
    end
    puts '✅ Conversion completed!'
  end
end

def convert_file_to_csv(file_path, output_directory)
  output_path = File.join(output_directory, "#{File.basename(file_path, '.txt')}.csv")

  headers = nil
  rows = []

  puts "🔍 Reading file: #{file_path}..."
  File.open(file_path, 'r').each_line do |line|
    line.strip!
    next if line.start_with?('----')

    if headers.nil?
      headers = parse_line(line)
      puts "📄 Detected headers: #{headers.join(', ')}"
    else
      row_data = parse_line(line)
      puts "🔵 Row: #{row_data.join(', ')}"
      rows << row_data
    end
  end

  puts "🖋 Writing to CSV file: #{output_path}..."
  CSV.open(output_path, 'wb') do |csv|
    csv << headers
    rows.each { |row| csv << row }
  end

  puts "✨ Successfully converted #{file_path} to #{output_path}."
end

def parse_line(line)
  line.split('|').map(&:strip)
end
