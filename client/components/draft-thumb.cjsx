VideoThumb = require('./video-thumb')
PhotoDraftThumb = require('./photo-draft-thumb')

module.exports = React.createClass
  displayName: 'DraftThumb'

  propTypes:
    draft: React.PropTypes.object.isRequired

  render: ->
    if @props.draft.type == 'VideoDraft'
      <VideoThumb video={@props.draft.video}/>
    else
      <PhotoDraftThumb photoDraft={@props.draft}/>
