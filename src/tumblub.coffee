React = require 'react'
jade = require 'react-jade'
#TumblubMenu = require './tumblubMenu'

template = jade.compile """
  div(idOrUrl=state.idOrUrl size=state.size speed=state.speed)
"""

Tumblub = React.createClass
  getInitialState: -> res =
    idOrUrl: 'just--space'
    size: '500'
    speed: '3200'
  render: -> template
    state: @state

module.exports = Tumblub
