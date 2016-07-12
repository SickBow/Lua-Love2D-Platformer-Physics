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
	
	self.addForce = function (forceX, forceY --[[use positive values]])
		self.forceX = forceX
		self.forceY = self.forceY + (-1)*forceY --makes adding force more intuitive
		
		if self.forceY > 0 then
		self.Y = self.Y - 1
		end
		
	end
	
	self.update = function (dt)
		
		if self.forceX < 0 then
			self.forceX = self.forceX + 10*(dt)
		elseif self.forceX > 0 then
			self.forceX = self.forceX - 10*(dt)
		end
		
		for  index,value in pairs(physics.world) do
		
			if self.Y + self.height > value.Y and self.X > value.X and self.X + self.width < value.X + value.width then
				self.grouned = true 
				self.Y = value.startY
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
		self.X = self.X + self.forceX
		
	end
	
	return self
end

--all physics objects created must be added to the world to use properly
function physics.add (object)
	table.insert(physics.world, object)
end

function physics.delete (object)
	table.remove(physics.world, object)
end

--must be placed in love.update(dt) function of your game 
function physics.update(dt)
	
	for  index,value in pairs(physics.world) do
		
		value.update(dt)
		
	end

end
