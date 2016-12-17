cx = require('classnames')
  
module.exports = React.createClass
  displayName: 'StravaBadge'

  render: ->
    <i className={cx('strava-badge', @props.className)}></i>
