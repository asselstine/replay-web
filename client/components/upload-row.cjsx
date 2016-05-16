module.exports = React.createClass
  displayName: 'UploadRow'

  propTypes:
    upload: React.PropTypes.object

  render: ->
    <div className='upload-row row'>
      <div className='col-xs-5'>
        {@props.upload.video.filename}
      </div>
      <div className='col-xs-3'>
      </div>
      <div className='col-xs-4'>
      </div>
    </div>
