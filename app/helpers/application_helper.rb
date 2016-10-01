module ApplicationHelper
  def flash_bootstrap_status_class(sym)
    case sym
    when :alert
      'danger'
    when :notice
      'info'
    when :warn
      'warning'
    else
      'info'
    end
  end

  def direct_upload_key_path
    "uploads/{timestamp}-{unique_id}-#{SecureRandom.hex}/${filename}"
  end

  def direct_upload_config(options = {})
    config_options = {
      acl: 'public-read',
      key: direct_upload_key_path,
      max_file_size: 5.gigabytes,
      key_starts_with: 'uploads/'
    }.merge options
    uploader = S3DirectUpload::UploadHelper::S3Uploader.new(config_options)
    {
      fields: uploader.fields,
      url: uploader.url
    }
  end

  def serialize_to_json(resource, options = {})
    options[:include] ||= '**'
    serializer = ActiveModelSerializers::SerializableResource.new(resource,
                                                                  options)
    # serializer = if resource.respond_to?(:to_ary)
    #                serialize_array_to_json(resource, options)
    #              else
    #                serialize_resource_to_json(resource, options)
    #              end
    serializer.as_json
  end
  #
  # def serialize_resource_to_json(resource, options)
  #   ActiveModelSerializers::SerializableResource.new(resource, options)
  # end
  #
  # def serialize_array_to_json(array, options)
  #   ActiveModel::Serializer::CollectionSerializer.new(array, options)
  # end
end
