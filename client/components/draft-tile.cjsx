DraftModal = require('./draft-modal')

module.exports = React.createClass
  displayName: 'DraftTile'

  propTypes:
    draft: React.PropTypes.object

  getInitialState: ->
    draftModalIsOpen: false

  openDraftModal: ->
    @setState(draftModalIsOpen: true)

  closeDraftModal: ->
    @setState(draftModalIsOpen: false)

  render: ->
    <div data-draft-id={@props.draft.id} className='draft-tile tile' onClick={@openDraftModal}>
      <img className='tile__img' src={@props.draft.video.thumbnail.small_url}/>
      <p>
        <small>{@props.draft.video.start_at}</small>
      </p>
      <p>
        {@props.draft.video.filename}
      </p>
      <VideoUploadModal draft={@props.draft}
                       isOpen={@state.draftModalIsOpen}
                       onRequestClose={@closeDraftModal}
                       onSuccess={@closeDraftModal}/>
    </div>
