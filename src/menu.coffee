React = require 'react'
{div, label, input, button} = React.DOM

Menu = React.createClass
  _onClick: (event)-> @props.onClick event

  render: ->
    div {}, [
      label({htmlFor: 'idOrUrl', key: 'idOrUrlLabel'}, 'ID or URL:')
      input({type: 'text', defaultValue: @props.idOrUrl, ref: 'idOrUrl', id: 'idOrUrl', key: 'idOrUrlInput'})
      button({onClick: @_onClick, key: 'menuChangeButton'}, 'Change')
    ]

module.exports = Menu
