StravaBadge = require('./strava-badge')
SegmentEffortMap = require('./segment-effort-map')

module.exports = React.createClass
  displayName: 'SegmentEffortOverlay'

  propTypes:
    activity: React.PropTypes.object.isRequired
    segmentEffort: React.PropTypes.object.isRequired
    eventEmitter: React.PropTypes.object.isRequired

  render: ->
    <div className='segment-effort-overlay'>
      <h4 className='segment-effort-overlay__title'>
        <StravaBadge/>
        {@props.segmentEffort.name}
        <SegmentEffortMap/>
      </h4>
    </div>
