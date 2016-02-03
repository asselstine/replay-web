class @Label extends React.Component
  @propTypes =
    label: React.PropTypes.string

  render: ->
    `<div>
      <div>Label: {this.props.label}</div>
    </div>`
