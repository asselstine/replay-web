@ViewSetup = React.createClass
  displayName: 'ViewSetup'

  propTypes:
    setup: React.PropTypes.object.isRequired

  render: ->
    <div>
      <SetupForm setup={@props.setup}/>
    </div>
