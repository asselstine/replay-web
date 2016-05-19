_ = require('lodash/core')
VideoDraftTile = require('./video-draft-tile')
PhotoDraftTile = require('./photo-draft-tile')

module.exports = React.createClass
  displayNames: 'Drafts'

  propTypes:
    drafts: React.PropTypes.array.isRequired

  render: ->
    tiles = _.map(@props.drafts, (draft) ->
      <div className='col-sm-3' key={draft.id}>
        {switch draft.type
          when 'VideoDraft' then <VideoDraftTile draft={draft}/>
          when 'PhotoDraft' then <PhotoDraftTile draft={draft}/>
          else <div>Unknown tile: {draft.type}</div>
        }
      </div>
    )

    <div className='drafts container'>
      <div className='row'>
        {tiles}
      </div>
    </div>
