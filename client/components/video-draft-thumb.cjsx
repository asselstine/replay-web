module.exports = React.createClass
  displayName: 'VideoDraftThumb'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  render: ->
    <div className='video-draft-thumb'>
      <a href={Routes.draft_path(@props.videoDraft)}>
        <img src={@props.videoDraft.video.thumbnail.small_url}/>
      </a>
      <h4>
        <b>
          {@props.videoDraft.video.filename}
        </b>
      </h4>
    </div>
