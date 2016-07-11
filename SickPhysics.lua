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
	self.forceX, self.forceY = 0,0
	
	self.addForce = function (forceX, forceY )
		self.forceX, self.forceY = forceX, forceY
	end
	
	self.update = function (deltaTime)
		
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
