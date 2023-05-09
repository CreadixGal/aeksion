require 'tty-prompt'

namespace :db do
  desc 'Restore the database'
  task restore: :environment do
    config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).first.configuration_hash

    prompt = TTY::Prompt.new
    files = Dir["#{Rails.root}/data/db_backup/*.sql"]
    filename = prompt.select("Select backup file to restore:", files)

    puts "username: #{config[:user]}"
    puts "host: #{config[:host]}"
    puts "port: #{config[:port]}"
    puts "database: #{config[:database]}"

    command = 'pg_restore '
    command += "--dbname=#{config[:database]} " # specify database name
    command += "--username=#{config[:user]} " if config[:user] # specify username
    command += "--host=#{config[:host]} " if config[:host] # specify host
    command += "--port=#{config[:port] || 5432} " # specify port
    command += "--verbose " # enable verbose mode
    command += "--clean " # clean (drop) database objects before recreating
    command += "--no-acl --no-owner " # prevent restoration of access privileges (optional)
    command += "#{filename}"

    puts "Command: #{command}"

    if Figaro.env.password_db?
      ENV['PGPASSWORD'] = Figaro.env.password_db
      puts "Restoring #{config[:database]} from #{filename}..."
      system(command)
      ENV['PGPASSWORD'] = nil
    else
      puts 'Error: no database password provided.'
    end

    puts 'Restore completed!'
  end
end
