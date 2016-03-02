$(document).ready ->
  Viewer = ->
    self = this

    this.posts = ko.observableArray()
    this.id = null
    this.custom = null
    this.random = 0
    this.ajaxLock = 0
    this.page = 0
    this.size = 500
    this.speed = 3600
    this.stock = 100

    this.init = ->
      query = window.location.search.substring 1
      params = query.split "&"
      query = []
      for param in params
        position = param.indexOf "="
        if position > 0
          key = param.substring 0, position
          value = param.substring position+1
          query[key] = value

      if query.id is ""
        query.id = "staff"

      if query.custom is ""
        query.custom = "www.davidslog.com"

      if query.id?
        this.id = query.id
      else if query.custom?
        this.custom = query.custom
      else
        query.id = "staff"

      if query.random?
        this.random = 1

      if query.size?
        query.size = parseInt query.size
        if query.size is 1280
          this.size = query.size
        else
          this.stock = 40

      if query.speed?
        query.speed = parseInt query.speed
        if query.speed >= 1000
          this.speed = query.speed

      this.loadPosts self.startSlideshow

    this.loadPosts = (callback)->
      params =
        size: self.size
      if this.id?
        idOrCustom = this.id
      else if this.custom?
        idOrCustom = this.custom
      unless self.random
        params.offset = self.page
      $.getJSON "//rpt.jgs.me/ps/#{idOrCustom}", params, (json)->
        for url in json
          self.posts.push url
        self.page += json.length
        callback()

    this.startSlideshow = ->
      arg = arguments
      $(".current:first").transition
        left: "-100%"
      , 800, "linear", ->
        $(".current:first").removeClass("current").addClass "finish"
      $(".wait:first").removeClass("wait").addClass "prev"
      $(".prev:first").transition
        left: "0%"
      , 800, "linear", ->
        $(".prev:first").removeClass("prev").addClass "current"
      if $(".wait").length < self.stock and self.ajaxLock is 0
        self.ajaxLock = 1
        self.loadPosts ->
          self.ajaxLock = 0
      $(".finish").remove()
      setTimeout arg.callee, self.speed

    this

  viewer = new Viewer()
  viewer.init()
  ko.applyBindings viewer
