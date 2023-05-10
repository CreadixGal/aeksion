require 'tty-prompt'
# rubocop:disable Metrics/BlockLength
namespace :db do
  desc 'Restore the database'
  task restore: :environment do
    config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).first.configuration_hash

    prompt = TTY::Prompt.new
    backup_directory = Pathname.new(Figaro.env.backup_directory)
    files = Dir[backup_directory.join('*.sql')]
    filename = prompt.select('Select backup file to restore:', files)

    command = 'pg_restore '
    command += "--dbname=#{config[:database]} " # specify database name
    command += "--username=#{Figaro.env.user_db} " if Figaro.env.user_db # specify username
    command += "--host=#{Figaro.env.host_db} " if Figaro.env.host_db # specify host
    command += "--port=#{config[:port] || 5432} " # specify port
    command += '--verbose ' # enable verbose mode
    command += '--clean ' # clean (drop) database objects before recreating
    command += '--no-acl --no-owner ' # prevent restoration of access privileges (optional)
    command += filename.to_s

    if Figaro.env.password_db?
      ENV['PGPASSWORD'] = Figaro.env.password_db
      puts "Restoring #{config[:database]} from #{filename}..."
      puts "Command: #{command}"
      system(command)
      ENV['PGPASSWORD'] = nil
    else
      puts 'Error: no database password provided.'
    end

    puts 'Restore completed!'
  end
end
# rubocop:enable Metrics/BlockLength
