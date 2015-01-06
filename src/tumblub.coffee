React = require 'react'
{div} = React.DOM
Menu = require './menu'
Slideshow = require './slideshow'

Tumblub = React.createClass
  getInitialState: ->
    idOrUrl: 'just--space'
    size: '500'
    speed: '3200'

  onClick: (event)->
    @setState
      idOrUrl: @refs.Menu.refs.idOrUrl.getDOMNode().value

  render: ->
    div {className: 'Tumblub'}, [
      React.createElement(Menu, {key: 'Menu', idOrUrl: @state.idOrUrl, size: @state.size, speed: @state.speed, onClick: @onClick, ref: 'Menu'})
      React.createElement(Slideshow, {key: 'Slideshow', idOrUrl: @state.idOrUrl, size: @state.size, speed: @state.speed})
    ]

module.exports = Tumblub
