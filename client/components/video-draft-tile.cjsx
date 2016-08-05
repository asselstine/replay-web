VideoDraftModal = require('./video-draft-modal')

module.exports = React.createClass
  displayName: 'VideoDraftTile'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  render: ->
    segmentEfforts = @props.videoDraft.segment_efforts.map (segmentEffort) =>
      <span key={segmentEffort.id}>{segmentEffort.name}</span>

    <div className='video-draft-tile'>
      <a href={Routes.draft_path(@props.videoDraft.id)} data-video-draft-id={@props.videoDraft.id}>
        <img className='tile__img'
             src={@props.videoDraft.source_video.thumbnail.small_url}/>
        <p>
          {@props.videoDraft.name}
        </p>
        {segmentEfforts}
      </a>
    </div>
