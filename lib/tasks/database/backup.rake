namespace :db do
  desc 'create a database backup in sql file format, and delete old backups (conserve last 3 backups more recents)'
  task backup: :environment do
    config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).first.configuration_hash
    puts config
    filename = Rails.root.join("data/db_backup/#{config[:database]}_backup_#{Time.zone.now.strftime('%Y%m%d')}.sql")

    command = 'pg_dump '
    # -U especifica el nombre de usuario de la base de datos
    command += "-U #{config[:user]} " if config[:user]
    # -h especifica el host de la base de datos
    command += "-h #{config[:host]} " if config[:host]
    # -p especifica el puerto de la base de datos
    command += "-p #{config[:port] || 5432} "
    # -F c selecciona el formato de archivo personalizado para la salida
    # -b incluye blobs
    # -v habilita el modo detallado (verbose)
    command += "-F c -b -v -f #{filename} #{config[:database]}"

    puts "Command: #{command}"

    if Figaro.env.password_db?
      ENV['PGPASSWORD'] = Figaro.env.password_db
      puts "Creating backup of #{config[:database]} at #{filename}..."
      system(command)
      ENV['PGPASSWORD'] = nil
    else
      puts 'Error: no database password provided.'
    end

    delete_old_backups

    puts 'Backup completed!'
  end
end

def delete_old_backups
  backup_files = Dir[Rails.root.join('data/db_backup/*.sql')].sort_by { |f| File.ctime(f) }
  return unless backup_files.length > 3

  files_to_delete = backup_files[0...-3]
  files_to_delete.each do |file|
    File.delete(file)
  end
  puts "Deleted #{files_to_delete.length} old backup(s)"
end
