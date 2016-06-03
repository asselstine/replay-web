VideoDraftModal = require('./video-draft-modal')

module.exports = React.createClass
  displayName: 'VideoDraftTile'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  getInitialState: ->
    videoDraftModalIsOpen: false

  openVideoDraftModal: ->
    @setState(videoDraftModalIsOpen: true)

  closeVideoDraftModal: ->
    @setState(videoDraftModalIsOpen: false)

  render: ->
    <div data-video-draft-id={@props.videoDraft.id} className='video-draft-tile' onClick={@openVideoDraftModal}>
      <img className='tile__img'
           src={@props.videoDraft.video.thumbnail.small_url}/>
      <p>
        {@props.videoDraft.activity.strava_name}
      </p>
      <VideoDraftModal videoDraft={@props.videoDraft}
                       isOpen={@state.videoDraftModalIsOpen}
                       onRequestClose={@closeVideoDraftModal}
                       onSuccess={@closeVideoDraftModal}/>
    </div>
