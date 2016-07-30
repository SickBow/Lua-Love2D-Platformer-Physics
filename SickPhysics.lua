physics = {}
physics.world = {}
--physics objects can be referenced and manipulated (adding force, subtracting force) with "physics.world.(object name here).(specific function name here)"
--this only works after adding them to the world/simulation due to them having unique names the user may create
--each object will be initialized with its own gravity, in case you want to make a bird or a static object (floors or surfaces)

--rectangular physics object to be added to the physics world
function physics:newRectangle ( startX, startY, width, height, gravity )
	self = {}
	
	--x and y will be in the top left of the object
	self.X, self.Y = startX, startY
	self.width, self.height = width, height
	self.gravity = gravity
	self.grounded = false
	self.airTimer = 0
	self.forceX, self.forceY = 0,0
	self.originX = self.width/2 + self.X
	self.originY = self.height/2 + self.Y
	
	self.setForce = function (forceX, forceY) --for fixed forces (walking or something else that is movement at a constant rate)
		if forceX ~= nil and forceX ~= 0 then
			self.forceX = forceX
		end
		if forceY ~= nil and forceY ~= 0 then
			self.forceY = forceY
		end
	end
	
	self.addForce = function (forceX, forceY --[[use positive values]])
		self.forceX = self.forceX + forceX
		self.forceY = self.forceY + (-1)*forceY --negating makes adding force more intuitive
		
		if self.forceY > 0 then
		self.Y = self.Y - 5
		self.grounded = false
		end
		
	end
	
	self.update = function (dt)
		
		--levelling out forceX
		if self.forceX < -1*15*(dt) then
			self.forceX = self.forceX + 15*(dt)
		else
			
		end
		if self.forceX > 15*dt then
			self.forceX = self.forceX - 15*(dt)
		else
			
		end
		
		
		for  index,value in pairs(physics.world) do
		
			if self.Y + self.height >= value.Y and self.X > value.X and self.X < value.X + value.width then
				self.grounded = true 
				self.Y = value.Y - self.height
			end
			
		end
		
		if self.grounded == true then
				self.forceY = 0
				self.airTimer = 0 
		else
				self.airTimer = self.airTimer + dt
				self.forceY = self.forceY+((self.airTimer)^2)*(self.gravity)
		end
		
		self.Y = self.Y + self.forceY
		self.originY = self.Y + self.height/2
		self.X = self.X + self.forceX
		self.originX = self.X + self.width/2
		
	end
	
	return self
end

--all physics objects created in your game must be added to the world with this function to use properly
--name is a string to use as a key when accessing the table
function physics.add (object, name)
	physics.world[name] = object
end

--use in your code to remove specified created collision object from game (when a character or enemy dies or something)
--name is a string to use as a key when accessing the table
function physics.delete (name)
	physics.world[name] = nil
end

--must be placed in love.update(dt) function of your game 
function physics.update(dt)

	for  index,value in pairs(physics.world) do
		value.update(dt)
	end
	
end

--used for visualizing collision bounds and debugging
--place function header in draw code of your game to visualize collision bounds of your physics objects 
function physics.drawBounds()
	
	for  index,value in pairs(physics.world) do
	
		love.graphics.rectangle("line",value.X,value.Y,value.width,value.height)
	
	end
	
end
