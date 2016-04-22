@NewCurrentSetupButton = React.createClass
  displayName: 'NewCurrentSetupButton'

  propTypes:
    cameras: React.PropTypes.array

  getDefaultProps: ->
    cameras: []

  create: ->


  render: ->
    <a onClick={@create} href='#'>New Camera Setup from my Location</a>
