local os,type=application:getDeviceInfo()
print ("os, type=",os, type)
--os,type="WinRT","Windows"

-- If the OS is WinRT then use lua class TextInputDialog2 as TextInputDialog
if (os=="WinRT") then
  TextInputDialog=TextInputDialog2
end

-- From here onwards, code is the same for all operating systems
local textInputDialog = TextInputDialog.new("Access code needed", "Enter access code here (case sensitive)", "init text", "cancel", "Yes", "No")

textInputDialog:setSecureInput(false)

local function onComplete(event)
	print(event.text, event.buttonIndex, event.buttonText)
	text:setText(event.text)
end

textInputDialog:addEventListener(Event.COMPLETE, onComplete)

text=TextField.new(nil,"The text you entered")
text:setPosition(100,100)
stage:addChild(text)

stage:addEventListener(Event.MOUSE_DOWN, function() textInputDialog:show() end)

------------------------------------------------------

--[[ 

Example code to show that TextInputDialog blocks all user interaction until dismissed
(but EnterFrame events are still processed)

Drag the shapes around with your mouse or fingers

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 

]]

local function onMouseDown(self, event)
	if self:hitTestPoint(event.x, event.y) then
		self.isFocus = true

		self.x0 = event.x
		self.y0 = event.y

		event:stopPropagation()
	end
end

local function onMouseMove(self, event)
	if self.isFocus then
		local dx = event.x - self.x0
		local dy = event.y - self.y0
		
		self:setX(self:getX() + dx)
		self:setY(self:getY() + dy)

		self.x0 = event.x
		self.y0 = event.y

		event:stopPropagation()
	end
end

local function onMouseUp(self, event)
	if self.isFocus then
		self.isFocus = false
		event:stopPropagation()
	end
end

for i=1,5 do
	local shape = Shape.new()
	
	shape:setLineStyle(3, 0x000000)
	shape:setFillStyle(Shape.SOLID, 0xff0000, 0.5)
	shape:beginPath()
	shape:moveTo(0, 0)
	shape:lineTo(100, 0)
	shape:lineTo(100, 50)
	shape:lineTo(0, 50)
	shape:closePath()
	shape:endPath()

	shape:setX(math.random(0, 320 - 100))
	shape:setY(math.random(0, 480 - 50))

	shape.isFocus = false

	shape:addEventListener(Event.MOUSE_DOWN, onMouseDown, shape)
	shape:addEventListener(Event.MOUSE_MOVE, onMouseMove, shape)
	shape:addEventListener(Event.MOUSE_UP, onMouseUp, shape)

	stage:addChild(shape)
end


local info = TextField.new(nil, "drag the shapes around with your mouse or fingers")
info:setPosition(23, 50)
stage:addChild(info)


