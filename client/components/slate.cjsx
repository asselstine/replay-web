cx = require('classnames')
moment = require('moment')

module.exports = React.createClass
  displayName: 'Slate'

  getInitialState: ->
    mom = moment(new GoTime())
    synced: window.GOTIME_SYNCED
    date: mom.format('MMM D YYYY Z')
    time: mom.format('HH:mm')
    seconds: mom.format('ss.SSS')

  update: ->
    @setState @getInitialState()

  componentDidMount: ->
    @interval = window.setInterval @update, 100

  componentWillUnmount: ->
    window.clearInterval(@interval)

  render: ->
    <div className={cx('slate', 'text-center', { 'not-synced' : !@state.synced })}>
      <h3 className='date'>{@state.date}</h3>
      <div className='time'>{@state.time}</div>
      <div className='seconds'>{@state.seconds}</div>
    </div>
