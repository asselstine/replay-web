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
    "direct_uploads/{timestamp}-{unique_id}-#{SecureRandom.hex}/${filename}"
  end

  def direct_upload_config(options = {})
    config_options = {
      acl: 'public-read',
      key: direct_upload_key_path,
      key_starts_with: 'direct_uploads/'
    }.merge options
    uploader = S3DirectUpload::UploadHelper::S3Uploader.new(config_options)
    {
      fields: uploader.fields,
      url: uploader.url
    }
  end

  def serialize_to_json(resource)
    serializer = if resource.respond_to?(:to_ary)
                   serialize_array_to_json(resource)
                 else
                   serialize_resource_to_json(resource)
                 end
    serializer.as_json
  end

  def serialize_resource_to_json(resource)
    ActiveModel::Serializer.serializer_for(resource).new(resource)
  end

  def serialize_array_to_json(array)
    ActiveModel::ArraySerializer.new(array)
  end
end
