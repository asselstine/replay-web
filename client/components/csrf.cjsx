module.exports = React.createClass

  getInitialState: ->
    token: ''

  componentDidMount: ->
    node = document.querySelector('meta[name="csrf-token"]')
    @setState(token: node.content) if node

  render: ->
    {token} = @state

    <input type="hidden" name="authenticity_token" value={token} />
