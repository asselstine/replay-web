VideoDraftModal = require('./video-draft-modal')

module.exports = React.createClass
  displayName: 'VideoDraftTile'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  render: ->
    segmentEfforts = @props.videoDraft.segment_efforts.map (segmentEffort) =>
      <span key={segmentEffort.id}>{segmentEffort.name}</span>

    <div className='video-draft-tile'>
      <a href={Routes.draft_path(@props.videoDraft.id)}>
        {@props.videoDraft.name}
      </a>
      {segmentEfforts}
    </div>
