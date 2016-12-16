VideoDraftThumb = require('./video-draft-thumb')
PhotoDraftThumb = require('./photo-draft-thumb')

module.exports = React.createClass
  displayName: 'DraftThumb'

  propTypes:
    draft: React.PropTypes.object.isRequired

  render: ->
    if @props.draft.type == 'VideoDraft'
      <VideoDraftThumb videoDraft={@props.draft}/>
    else
      <PhotoDraftThumb photoDraft={@props.draft}/>
