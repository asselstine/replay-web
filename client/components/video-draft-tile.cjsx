VideoDraftModal = require('./video-draft-modal')
VideoThumb = require('./video-thumb')

module.exports = React.createClass
  displayName: 'VideoDraftTile'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  render: ->
    segmentEfforts = @props.videoDraft.segment_efforts.map (segmentEffort) =>
      <span key={segmentEffort.id}>{segmentEffort.name}</span>

    <div className='video-draft-tile' data-video-draft-id={@props.videoDraft.id}>
      <a href={Routes.draft_path(@props.videoDraft.id)}>
        <VideoThumb video={@props.videoDraft.video}/>
      </a>
      {segmentEfforts}
    </div>
