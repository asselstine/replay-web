import React from 'react'
import MapBrowser from './map-browser'
import DraftRoute from './draft-route'

module.exports = React.createClass({
  displayName: 'DraftsMap',

  propTypes: {
    drafts: React.PropTypes.array
  },

  onClick (e, draftRoute) {
    window.location = Routes.draft_path(draftRoute.props.draft.id)
  },

  render () {
    return (
      <MapBrowser drafts={this.props.drafts}>
        {this.props.drafts.map((draft) => {
          return (
            <DraftRoute key={draft.id}
              onClick={this.onClick}
              showHoverCircle={false}
              draft={draft} />
          )
        })}
      </MapBrowser>
    )
  }
})
