class View
	subviews: []
	constructor: (@element)->
		element = "DIV" if not element?
	
		if typeof element is "string"
			@element = document.createElement element
		else 
			@element = element
		
		@element.isView = yes
		document.body.appendChild @element
		
		@subviews = []
		@render()

	update: () ->
		@render()

	render: () ->
		# content = document.createTextNode "Hello"
		# @element.appendChild content
	
	addSubview: (aView) ->
		if aView in @subviews 
			return aView
		@subviews.push aView		
		@element.appendChild aView.element


class SliderView extends View
	constructor: (func) ->
		super('input')
		@element.type = 'range'
		@element.min = 0.5
		@element.max = 5
		@element.step = 0.001
		@element.onchange = func 
		@element.value = 1.0
	value:	(value) ->
		@element.value = 1.0 * value
		@element.onchange()

class SearchView extends View
#      contructor: (func) ->
#        super('input')
#        @element.onKeyUp = (event) ->
#		  		   func(event) if  event.keyCode == 13

class SearchView extends View
        constructor: (func) ->
                super('input')
                @element.type = 'search'
                @element.onkeyup = (event)->
                   func event if event.keyCode == 13
                label = document.createElement("label")
                #@element.parent.appendChild()

class CheckBoxView extends View
	constructor: (title, func) ->
		super('input')
		@element.type = 'checkbox'
		@element.checked = no
		@element.onchange = func
		label = document.createElement("label")
		#@element.parent.appendChild()


class PlanetView extends View
	planetNames: []
	planetCoordinates: []
	canvas: null
	scale: 1.0
	maxDistance: 84.5
	dimension: [4000, 4000]
	offset: [0, 0]
	drawsLines: no
	lineColor: 'rgba(0,255,255,0.25)'
	planetColor: 'white'
	textColor: 'cyan'
	
	constructor:(slider)->	
		@fetchPlanetNames()
		@fetchPlanetCoordinates()
		super()
		@slider = slider
		@element.appendChild (@canvas = document.createElement "canvas")
		@canvas.width = document.body.clientWidth
		
		window.addEventListener("resize", (event) =>
			@canvas.width = document.body.clientWidth - 100
			@update()
		)
		@canvas.height = 800
		@canvas.style.cursor = "move"
		mouseIsDown = no
		lastEvent = null
		@canvas.addEventListener "mousedown", (event)=>
			mouseIsDown = yes
			lastEvent = event
		@canvas.addEventListener "mouseup", (event)=>
			mouseIsDown = no
			lastEvent = null
		@canvas.addEventListener "mousewheel", (event)=>
			if event.wheelDelta > 0
				newValue = @scale + 0.1
			else
				newValue = @scale - 0.1
			@slider.value newValue
		@canvas.addEventListener "mousemove", (event)=>
			if mouseIsDown
				@mouseDragged event, lastEvent
				lastEvent = event
		@image = new Image();
		@image.onload = () =>
		  @update()
		@image.src = "data:image/png;base64,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"

	mouseDragged: (event, lastEvent) ->
		x = (event.clientX - lastEvent.clientX) * (1 / @scale)
		y = (event.clientY - lastEvent.clientY) * (1 / @scale)
		@offset = [@offset[0] + x, @offset[1] + y]
		@constrainOffset()
		@update()
	constrainOffset: () ->
		@offset[0] = -2000 if @offset[0] < -2000
		@offset[1] = -2000 if @offset[1] < -2000
		@offset[0] = 2000 if @offset[0] > 2000
		@offset[1] = 2000 if @offset[1] > 2000
		@offset[1] = 0 if window.isNaN @offset[1]
		@offset[0] = 0 if window.isNaN @offset[0]
		
	center: (coordinate) ->
		@offset[0] = (2000 - coordinate[0] ) 
		@offset[1] = (coordinate[1] - 2000 )  
		@constrainOffset()
		@update()

	searchPlanet: (planetName) ->
		return if not planetName? 
		coord
		for index in [0..@planetNames.length-1]
                        if @planetNames[index].toLowerCase().indexOf(planetName.toLowerCase()) isnt -1
                                coord = @planetCoordinates[index]
                                break
                
		@center coord if coord?


	setScale: (newScale) ->
		@scale = parseFloat newScale
		@update()

	appendText: (text)->
		element = document.createElement "div"
		@element.appendChild element
		text = document.createTextNode text
		element.appendChild text
		
	render: () ->
		return no if @planetNames.length isnt 500
		return no if @planetCoordinates.length isnt 500
		context = @canvas.getContext '2d'
		context.fillStyle = 'rgba(0,0,0,1)'
		context.fillRect 0, 0, @canvas.width, @canvas.height
		
		@drawLines(context) if @drawsLines
		@drawPlanets(context)
		
	drawPlanets: (context) ->
		for i in [0..@planetNames.length-1]
			@drawPlanet context, i

	generateLines: () ->
		distance = (coord1, coord2) ->
			square = (x) -> x * x
			d = Math.sqrt( square(coord2[0] - coord1[0]) + square(coord2[1] - coord1[1]) )
			return d

		lines = []
		upperBound = @planetCoordinates.length-1
		for index1 in [0..upperBound]
			for index2 in [index1..upperBound]
				coord1 = @planetCoordinates[index1]
				coord2 = @planetCoordinates[index2]
				lines.push [coord1, coord2] if distance(coord1, coord2) < @maxDistance
		@lines = lines
		@update()

	
	drawLines: (context) ->
		if not @lines?
			@generateLines()
		for line in @lines
			@drawLine(context, line)
		

	scaleCoordinates: (coord) ->
		x = 4000 - Math.round((coord[0] - @offset[0]) *  @scale) - @canvas.width / 2
		y = 4000 - Math.round((coord[1] - @offset[1]) *  @scale) -  @canvas.height / 2

		x = (coord[0] - (@dimension[0] / 2) + @offset[0]) * @scale + @canvas.width / 2
		y = (4000 - coord[1] - (@dimension[1] / 2) + @offset[1])  * @scale +  @canvas.height / 2
		
		return [x, y]

	drawPlanet: (context, nr ) ->

		coord = @planetCoordinates[nr]
		name  = @planetNames[nr]
		
		scaledCoord = @scaleCoordinates(coord)
		x = scaledCoord[0]
		y = scaledCoord[1]
		
		return if not (@canvas.width > x > 0 )
		return if not (@canvas.height > y > 0)
		
		if @scale < 1.5
			context.fillStyle = @planetColor
			@drawCircle context, x, y
		else
			@drawPlanetImage context, x, y
		
		context.fillStyle = @textColor
		nameAdjustment = context.measureText(name).width/2
		context.fillText(name, x - nameAdjustment, y+12 + (1*@scale))
		
	drawPlanetImage: (context, x, y) ->
		@image
		width = 1 + 4 *  @scale
		height = 1 + 4 * @scale
		context.drawImage @image, x - (width/2), y - (height/2), width, height

	
	
	drawLine: (context, line) ->
		coord1 =  @scaleCoordinates(line[0])
		coord2 =  @scaleCoordinates(line[1])
		return unless (@canvas.width + @maxDistance > coord1[0] > (0 - @maxDistance)) or
				      (@canvas.width + @maxDistance > coord2[0] > (0 - @maxDistance)) or
				      (@canvas.height + @maxDistance > coord1[1] > (0 - @maxDistance)) or
				      (@canvas.height + @maxDistance > coord2[1] > (0 - @maxDistance))
		context.lineWidth = 1 # if @scale < 1 then 1 else 1 * @scale
		context.strokeStyle = @lineColor
		context.beginPath()
		context.moveTo coord1[0], coord1[1]
		context.lineTo coord2[0], coord2[1]
		context.stroke()

	
		
	drawCircle: (context, left, right) ->
		circleSize = 2
		context.beginPath()
		context.arc(left-(circleSize/2), right-(circleSize/2), circleSize, 0, Math.PI * 2, true)
		context.closePath()
		context.fill()
			
	fetchPlanetNames: ()->
		self = this
		xhr = new XMLHttpRequest()
		xhr.open 'GET', 'PLANET.NM', true
		xhr.overrideMimeType = 'text/plain; charset=x-user-defined'
		xhr.responseType = 'text'
		xhr.onload = (event) ->
			self.didFetchPlanetNames(planetName.trimRight() for planetName in @response.match(/.{1,20}/g))
		xhr.onerror = (event) ->
			console.log event
		xhr.send()

	didFetchPlanetNames: (names)->
		@planetNames = names
		@update()
	
	fetchPlanetCoordinates: () ->
		self = this
		xhr = new XMLHttpRequest()
		xhr.open 'GET', 'XYPLAN.DAT', true
		xhr.overrideMimeType = 'text/plain; charset=x-user-defined'
		xhr.responseType = 'arraybuffer'
		xhr.onload = (event) ->
			self.didFetchPlanetCoordinates(new Uint8Array(@response))
		xhr.onerror = (event) ->
			console.log event
		xhr.send()

	didFetchPlanetCoordinates: (coordinates) ->
		@planetCoordinates = []
		i = 0
		for n in [1..500]

			x1 = coordinates[i]
			x2 = coordinates[i+1]*256
			x = x1+x2
			y1 = coordinates[i+2]
			y2 = coordinates[i+3]*256
			y = y1+y2
			@planetCoordinates.push([x,y])
			i = i + 6
		@update()

	shouldDrawLines: (shouldDraw) ->
		@drawsLines = shouldDraw
		@update()


window.ready =  () ->
	planetView = null
	slider = new SliderView(()->
		planetView.setScale slider.element.value
	)
	checker = new CheckBoxView('show warp-routes', ()->
		planetView.shouldDrawLines (checker.element.checked)
	)
	searcher = new SearchView((even) -> planetView.searchPlanet(searcher.element.value))
	planetView =  new PlanetView(slider)
