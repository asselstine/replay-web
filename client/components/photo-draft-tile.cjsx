module.exports = React.createClass
  displayName: 'PhotoDraftTile'

  propTypes:
    photoDraft: React.PropTypes.object.isRequired

  render: ->
    <div className='photo-draft-tile'>
      <img className='tile__img' src={@photoDraft.photo.small_url}/>
    </div>
