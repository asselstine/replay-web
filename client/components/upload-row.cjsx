module.exports = React.createClass
  displayName: 'UploadRow'

  propTypes:
    upload: React.PropTypes.object

  render: ->
    <div className='upload-row row'>
      <div className='col-xs-5'>
        <a href={Routes.upload_path(@props.upload)}>{@props.upload.video.filename}</a>
      </div>
      <div className='col-xs-3'>
      </div>
      <div className='col-xs-4'>
      </div>
    </div>
