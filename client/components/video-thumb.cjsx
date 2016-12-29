module.exports = React.createClass
  displayName: 'VideoThumb'

  propTypes:
    video: React.PropTypes.object.isRequired

  render: ->
    <div className='video-thumb'>
      {@props.video.filename}
    </div>
