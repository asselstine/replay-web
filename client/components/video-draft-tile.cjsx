VideoDraftModal = require('./video-draft-modal')

module.exports = React.createClass
  displayName: 'VideoDraftTile'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired
  #
  # getInitialState: ->
  #   videoDraftModalIsOpen: false
  #
  # openVideoDraftModal: ->
  #   @setState(videoDraftModalIsOpen: true)
  #
  # closeVideoDraftModal: ->
  #   @setState(videoDraftModalIsOpen: false)

  render: ->
    <div className='video-draft-tile'>
      <a href={Routes.draft_path(@props.videoDraft.id)} data-video-draft-id={@props.videoDraft.id}>
        <img className='tile__img'
             src={@props.videoDraft.source_video.thumbnail.small_url}/>
        <p>
          {@props.videoDraft.name}
        </p>
      </a>
    </div>
