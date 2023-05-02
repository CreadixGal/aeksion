namespace :database do
  desc 'Export database to a JSON file'
  task export: :environment do
    puts 'Exporting data...'

    data = {
      users: User.all.as_json,
      zones: Zone.all.as_json,
      customers: Customer.all.as_json,
      delivery_riders: DeliveryRider.all.as_json,
      rates: Rate.all.as_json,
      products: Product.all.as_json,
      variants: Variant.all.as_json,
      movements: Movement.all.as_json,
      product_movements: ProductMovement.all.as_json,
      prices: Price.all.as_json,
      issue_trackers: IssueTracker.all.as_json,
      comments: Comment.all.as_json,
      active_storage_blobs: ActiveStorage::Blob.all.as_json,
      active_storage_attachments: ActiveStorage::Attachment.all.as_json,
      active_storage_variant_records: ActiveStorage::VariantRecord.all.as_json
    }

    file_name = "#{Time.zone.now.strftime('%H%M%d%m%y')}_database_backup.json"
    file_path = Rails.root.join('data', file_name)

    File.write(file_path, JSON.pretty_generate(data))

    puts "Data exported successfully to #{file_path}"
  end
end
