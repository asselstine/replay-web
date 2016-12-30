DraftThumb = require('./draft-thumb')

module.exports = React.createClass
  displayName: 'ActivityRowSegmentEffort'

  propTypes:
    segmentEffort: React.PropTypes.object.isRequired

  render: ->
    <div className='activity-row-segment-effort'>
      <h3>
        <i className='segment-effort-badge'></i>
        {@props.segmentEffort.name}
      </h3>
      <div className='row'>
        {@props.segmentEffort.drafts.map (draft) =>
          <div className='col-xs-4' key={draft.id}>
            <a href={Routes.draft_path(draft.id)}>
              <DraftThumb draft={draft}/>
            </a>
          </div>
        }
      </div>
    </div>
