format = require('../util/format')

module.exports = React.createClass
  displayName: 'JobRow'

  propTypes:
    job: React.PropTypes.object.isRequired

  render: ->
    <div className='job-row row'>
      <div className='col-sm-2'>
        {@props.job.status}
      </div>
      <div className='col-sm-2'>
        {@props.job.message}
      </div>
    </div>
