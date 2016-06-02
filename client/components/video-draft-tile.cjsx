module.exports = React.createClass
  displayName: 'VideoDraftTile'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  render: ->
    <div className='video-draft-tile'>
      <img className='tile__img'
           src={@props.videoDraft.video.thumbnail.small_url}/>
      <p>
        {@props.videoDraft.video.filename}
      </p>
    </div>
