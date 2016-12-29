module.exports = React.createClass
  displayName: 'JobsListRow'

  propTypes:
    job: React.PropTypes.object.isRequired

  render: ->
    <div className='jobs-list-row row'>
      <div className='col-sm-4'>
        {@props.job.upload.filename}
      </div>
      <div className='col-sm-2'>
        {@props.job.status}
      </div>
      <div className='col-sm-6'>
        {@props.job.message}
      </div>
    </div>
