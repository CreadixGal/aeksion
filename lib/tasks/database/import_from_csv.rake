# lib/tasks/import_csv.rake

require 'csv'

namespace :db do
  desc "Importa datos desde archivos CSV en lib/tasks/database/converted_csv"
  task import_csv: :environment do
    csv_files_path = Rails.root.join('lib', 'tasks', 'database', 'converted_csv', '*.csv')

    # Recorremos cada archivo en el directorio
    Dir[csv_files_path].each do |csv_file|
      begin
        # Usamos el nombre del archivo (sin la extensión) para identificar el modelo
        order, name = divide_filename(csv_file)
        model_name = name.classify
        model = model_name.constantize

        puts "🔄 Importando datos para #{model_name} desde #{csv_file}"

        CSV.foreach(csv_file, headers: true) do |row|
          # Verifica si el registro ya existe basándose en el UUID
          if model.exists?(id: row['id'])
            puts "   ⚠️  Registro con ID: #{row['id']} ya existe. Se omite la importación."
            next
          end

          # Convertimos la fila a un hash y lo usamos para crear una nueva instancia del modelo
          record = model.new(row.to_hash)
          record.save!

          puts "   ✔️  Importado registro con ID: #{row['id']}"
        end

        puts "✅ Datos para #{model_name} importados con éxito."
      rescue => e
        puts "❌ Hubo un error al importar los datos para #{model_name}. Error: #{e.message}"
      end
    end

    puts "🎉 Proceso de importación finalizado."
  end
end

def divide_filename(filepath)
  # Primero obtenemos solo el nombre del archivo, excluyendo la ruta completa
  filename = File.basename(filepath)

  # Dividir el nombre usando el guion bajo como delimitador
  parts = filename.split('_')
  
  # El primer elemento del array 'parts' contiene el número de orden
  order_number = parts[0].to_i
  
  # El resto del array se unirá para formar el nombre de la tabla
  table_name = parts[1..-1].join('_').gsub('.csv', '')
  
  puts "DEBUG: filepath=#{filepath}, order_number=#{order_number}, table_name=#{table_name}"
  
  return order_number, table_name
end
