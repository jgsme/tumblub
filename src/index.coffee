React = require 'react'
Tumblub = require './tumblub'

React.render React.createFactory(Tumblub)(), document.getElementById('container')
