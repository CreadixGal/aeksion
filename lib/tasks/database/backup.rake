namespace :db do
  desc 'Backup the database'
  task backup: :environment do
    config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).first.configuration_hash

    backup_directory = Pathname.new(Figaro.env.backup_directory)
    FileUtils.mkdir_p(backup_directory) unless File.directory?(backup_directory)
    filename = backup_directory.join("#{config[:database]}_backup_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.sql")

    command = 'pg_dump '
    command += "-U #{Figaro.env.user_db} " if Figaro.env.user_db?
    command += "-h #{Figaro.env.host_db} " if Figaro.env.host_db?
    command += "-p #{config[:port] || 5432} "
    command += "-F c -b -v --no-owner --no-acl -f #{filename} #{config[:database]}"

    if Figaro.env.password_db?
      ENV['PGPASSWORD'] = Figaro.env.password_db
      puts "Command: #{command}"
      system(command)
      puts "Creating backup of #{config[:database]} at #{filename}..."
      ENV['PGPASSWORD'] = nil
    else
      puts 'Error: no database password provided.'
    end

    backup_files = Dir.glob(backup_directory.join('*.sql'))
    files_to_delete = backup_files.sort_by { |file| File.mtime(file) }[0...-3]
    files_to_delete.each { |file| File.delete(file) }

    puts 'Backup completed!'
  end
end
