ActivityRow = require('./activity-row')

module.exports = React.createClass
  displayName: 'Activities'

  propTypes:
    activities: React.PropTypes.array.isRequired

  render: ->
    <div className='activities container'>
      {@props.activities.map (activity) =>
        <ActivityRow activity={activity} key={activity.id}/>
      }
    </div>
