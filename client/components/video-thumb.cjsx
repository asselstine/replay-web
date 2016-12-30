module.exports = React.createClass
  displayName: 'VideoThumb'

  propTypes:
    video: React.PropTypes.object.isRequired

  render: ->
    output = @props.video.outputs[0]
    thumbnail_url = output.thumbnail_urls[0]
    style =
      backgroundImage: 'url(' + thumbnail_url + ')'
    <div className='video-thumb' style={style}>
    </div>
