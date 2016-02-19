class S3Uploader extends ComponentBase
  name: 's3-uploader'
  constructor: ->
    super
    @$progressBars = @$el.find('.progress-bars')
    @$el.S3Uploader
      progress_bar_target: @$progressBars
      allow_multiple_files: false
      remove_completed_progress_bar: false
    @$el.on 's3_upload_complete', (e, content) =>
      $("input[name='video[source_url]']").val(decodeURIComponent(content.url))

window.S3Uploader = S3Uploader
