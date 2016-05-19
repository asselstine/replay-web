module.exports = React.createClass
  displayName: 'VideoDraftTile'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  render: ->
    <div className='video-draft-tile'>
      <img className='tile__img' src={@videoDraft.thumbnail.small_url}/>
    </div>
