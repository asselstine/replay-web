module.exports = React.createClass
  displayName: 'UploadTile'

  propTypes:
    upload: React.PropTypes.object

  render: ->
    <div className='pending-upload-tile tile'>
      <p>
        Unprocessed upload
      </p>
      <p>
        {@props.upload.filename}
      </p>
    </div>
