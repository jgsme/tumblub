$(document).ready ->
	Viewer = ->
		self = this

		this.posts = ko.observableArray()
		this.id = null
		this.custom = null
		this.random = 0
		this.ajaxLock = 0
		this.page = 0
		
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
			if query.id?
				this.id = query.id
			else if query.custom?
				this.custom = query.custom
			if query.random?
				this.random = 1
			this.loadPosts self.startSlideshow
		
		this.loadPosts = (callback)->
			params = 
				page: self.page
				random: self.random
			if this.id?
				params.id = this.id
			else if this.custom?
				params.custom = this.custom
			$.getJSON "/api", params, (json)->
				if json.status is "success"
					for post in json.posts
						self.posts.push post 
					self.page += json.posts.length
					callback()

		this.startSlideshow = ->
			arg = arguments
			$(".current:first").animate
				left: "-100%"
			, 800, "linear", ->
				$(".current:first").removeClass("current").addClass "finish"
			$(".wait:first").removeClass("wait").addClass "prev"
			$(".prev:first").animate
				left: "0%"
			, 800, "linear", ->
				$(".prev:first").removeClass("prev").addClass "current"
			if $(".wait").length < 100 and self.ajaxLock is 0
				self.ajaxLock = 1
				self.loadPosts ->
					self.ajaxLock = 0
			setTimeout arg.callee, 3600

		this

	viewer = new Viewer()
	viewer.init()
	ko.applyBindings viewer
