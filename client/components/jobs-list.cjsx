JobsListRow = require('./jobs-list-row')

module.exports = React.createClass
  displayName: 'JobsList'

  propTypes:
    jobs: React.PropTypes.array.isRequired

  render: ->
    <div className='jobs-list'>
      {@props.jobs.map (job) ->
        <JobsListRow job={job} key={job.id}/>
      }
    </div>
