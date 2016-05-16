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

  # JavaScript: direct_upload_config: JSON.parse('#{raw direct_upload_config.to_json}'),
  def direct_upload_config(options = {})
    config_options = {
      acl: 'public-read',
      key: "direct_uploads/{timestamp}-{unique_id}-#{SecureRandom.hex}/${filename}",
      key_starts_with: 'direct_uploads/'
    }.merge options
    uploader = S3DirectUpload::UploadHelper::S3Uploader.new(config_options)
    {
      fields: uploader.fields,
      url: uploader.url
    }
  end
end
