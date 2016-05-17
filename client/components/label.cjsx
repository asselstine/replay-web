module.exports = React.createClass
  displayName: 'Label'
  
  @propTypes =
    label: React.PropTypes.string

  render: ->
    `<div>
      <div>Label: {this.props.label}</div>
    </div>`
