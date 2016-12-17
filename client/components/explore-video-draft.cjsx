DataVideoPlayer = require('./data-video-player')

module.exports = React.createClass
  displayName: 'ExploreVideoDraft'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  render: ->
    <div className='explore-video-draft'>
      <DataVideoPlayer videoDraft={@props.videoDraft}/>
    </div>
