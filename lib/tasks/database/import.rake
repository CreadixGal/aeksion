# frozen_string_literal: true

namespace :database do
  desc 'Import data from a JSON file'
  task :import, [:file_path] => :environment do |_, args|
    file_path = args['file_path']

    if file_path.blank?
      puts 'Please provide a file path as an argument. Example: `bin/rails import[path/to/your/file.json]`'
      exit
    end

    file_path = Rails.root.join(file_path)

    unless File.exist?(file_path)
      puts "File not found at #{file_path}. Please provide a valid file path."
      exit
    end

    import_data(file_path)
  end
end

def import_data(file_path)
  puts "Importing data from #{file_path}..."
  json_data = JSON.parse(File.read(file_path))

  ActiveRecord::Base.transaction do
    json_data.each do |model, records|
      klass = classify_model(model)

      records.each do |record|
        record = record.except('attachable_sgid') if klass == ActiveStorage::Blob
        process_record(klass, record)
      end

      puts "Imported #{records.count} #{model}"
    end
  end

  puts 'Data import completed successfully.'
end

def classify_model(model)
  case model
  when 'active_storage_blobs'
    ActiveStorage::Blob
  when 'active_storage_attachments'
    ActiveStorage::Attachment
  when 'active_storage_variant_records'
    ActiveStorage::VariantRecord
  else
    model.classify.constantize
  end
end

def process_record(klass, record)
  if klass == User && record['password'].blank?
    puts "Estableciendo contraseña 'test123' para el usuario con ID #{record['id']} debido a una contraseña vacía"
    record['password'] = 'test123'
  end

  imported_record = klass.new(record.except(*klass.reflections.keys))
  set_associations(klass, record, imported_record)

  imported_record.save!
end

def set_associations(klass, record, imported_record)
  record = record.except('attachable_sgid') if klass == ActiveStorage::Blob

  klass.reflections.each do |association_name, reflection|
    next if record[association_name].blank?

    association_class = reflection.class_name.constantize
    associated_records = record[association_name].filter_map do |assoc_record|
      association_class.find_by(assoc_record)
    end
    imported_record.send("#{association_name}=", associated_records)
  end
end
