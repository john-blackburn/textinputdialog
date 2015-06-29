TIDButton=Core.class(Sprite)

function TIDButton:init(width,height,text)
local font=TTFont.new("arial.ttf",20,true)

local rect=Shape.new()
rect:setFillStyle(Shape.SOLID,0xFFFFFF)
rect:setLineStyle(3,0x0)
rect:moveTo(-width/2,-height/2)
rect:lineTo(width/2,-height/2)
rect:lineTo(width/2,height/2)
rect:lineTo(-width/2,height/2)
rect:closePath()
rect:endPath()
self:addChild(rect)

local t=TextField.new(font,text)
local w=t:getWidth()
local h=t:getHeight()
t:setPosition(-w/2,h/2)
self:addChild(t)
end

--############################################

TextInputDialog2 = Core.class(Sprite)

TextInputDialog2.EMAIL="email"
TextInputDialog2.NUMBER="number"
TextInputDialog2.PHONE="phone"
TextInputDialog2.TEXT="text"
TextInputDialog2.URL="url"

--############################################

function TextInputDialog2:init(title, message, text, cancelButton, button1, button2)

local whiteThickness=250
local buttonWidth=100
local buttonHeight=40
local buttonSep=20

self.cancelButton=cancelButton
self.button1=button1
self.button2=button2
self.secure=false

local screenw=application:getLogicalWidth()
local screenh=application:getLogicalHeight()

print ("screenw,screenh=",screenw,screenh)

local os,type=application:getDeviceInfo()
--os,type="WinRT","Windows"

local bigFont=TTFont.new("arial.ttf",40,true)
local smallFont=TTFont.new("arial.ttf",20,true)

---------------------------------------------
-- Background grey box
---------------------------------------------

local r=Shape.new()
r:setFillStyle(Shape.SOLID,0x808080,0.5)

if os=="WinRT" and type=="Windows" then
  r:moveTo(0,0)
  r:lineTo(screenh,0)
  r:lineTo(screenh,screenw)
  r:lineTo(0,screenw)
else
  r:moveTo(0,0)
  r:lineTo(screenw,0)
  r:lineTo(screenw,screenh)
  r:lineTo(0,screenh)
end

r:closePath()
r:endPath()

self:addChild(r)

---------------------------------------------
-- White box behind dialog
---------------------------------------------

local r2=Shape.new()
r2:setFillStyle(Shape.SOLID,0xFFFFFF)

if os=="WinRT" and type=="Windows" then
  r2:moveTo(0,0)
  r2:lineTo(screenh,0)
  r2:lineTo(screenh,whiteThickness)
  r2:lineTo(0,whiteThickness)
  r2:setY(screenw/2-whiteThickness/2)
else
  r2:moveTo(0,0)
  r2:lineTo(screenw,0)
  r2:lineTo(screenw,whiteThickness)
  r2:lineTo(0,whiteThickness)
end

r2:closePath()
r2:endPath()

self:addChild(r2)

---------------------------------------------
-- Title textfield
---------------------------------------------

local w
local titleText=TextField.new(bigFont,title)
w=titleText:getWidth()

if os=="WinRT" and type=="Windows" then
  titleText:setPosition(screenh/2-w/2,50+screenw/2-whiteThickness/2)
else
  titleText:setPosition(screenw/2-w/2,50)
end

self:addChild(titleText)

---------------------------------------------
-- Message TextField
---------------------------------------------

local messageText=TextField.new(smallFont,message)
w=messageText:getWidth()

if os=="WinRT" and type=="Windows" then
  messageText:setPosition(screenh/2-w/2,90+screenw/2-whiteThickness/2)
else
  messageText:setPosition(screenw/2-w/2,90)
end

self:addChild(messageText)

---------------------------------------------
-- Create a soft keyboard for Windows Phone
---------------------------------------------

local keyboard

if type=="Windows Phone" then
  keyboard = KeyBoard.new()
  keyboard:Create()
  self:addChild(keyboard)
end

---------------------------------------------
-- Create InputBox
---------------------------------------------

local inputbox = InputBox.new(0,0,screenw,40)

if os=="WinRT" and type=="Windows" then
  inputbox:setPosition(screenh/2-screenw/2,120+screenw/2-whiteThickness/2)
else
  inputbox:setPosition(0,120)
end

inputbox:setText(text)

if type=="Windows Phone" then
  inputbox:SetKeyBoard(keyboard)
else
  inputbox:SetKeyBoard(nil)   -- take input from physical keyboard
end

inputbox:setBoxColors(0xefefef,0xff2222,0,1)
inputbox:setActiveBoxColors(0xff5555,0xff2222,0,1)
self:addChild(inputbox)
self.inputbox=inputbox

---------------------------------------------
-- Calculate starting x coord for buttons
---------------------------------------------

local nbuttons=1
if button1 then
  nbuttons=nbuttons+1
end

if button2 then
  nbuttons=nbuttons+1
end

local xbutton
local dist
if os=="WinRT" and type=="Windows" then
  dist=screenh
else
  dist=screenw
end

if nbuttons==1 then
  xbutton=dist/2
elseif nbuttons==2 then
  xbutton=dist/2-buttonWidth/2-buttonSep/2
else
  xbutton=dist/2-buttonWidth-buttonSep
end

---------------------------------------------
-- Create max 3 buttons
---------------------------------------------

local y
if os=="WinRT" and type=="Windows" then
  y=200+screenw/2-whiteThickness/2
else
  y=200
end

if (button1) then
  self.b1Button=TIDButton.new(buttonWidth,buttonHeight,button1)
  self.b1Button:setPosition(xbutton,y)
  self:addChild(self.b1Button)
  xbutton=xbutton+buttonWidth+buttonSep
end

if (button2) then
  self.b2Button=TIDButton.new(buttonWidth,buttonHeight,button2)
  self.b2Button:setPosition(xbutton,y)
  self:addChild(self.b2Button)
  xbutton=xbutton+buttonWidth+buttonSep
end

self.cButton=TIDButton.new(buttonWidth,buttonHeight,cancelButton)
self.cButton:setPosition(xbutton,y)
self:addChild(self.cButton)

---------------------------------------------
-- Add event listener to this dialog
-- For Windows Phone, rotate dialog if in Landscape mode
---------------------------------------------

self:addEventListener(Event.MOUSE_DOWN,self.onClick,self)

if (type=="Windows Phone" and application:getOrientation()==Application.LANDSCAPE_LEFT) then
  self:setRotation(-90)
  self:setY(screenw)
end

end

--############################################

function TextInputDialog2:onClick(event)
if (self.cButton:hitTestPoint(event.x,event.y)) then
  self:removeFromParent()

  local e=Event.new("complete")
  e.text=self.inputbox:getText()
  e.buttonIndex=nil
  e.buttonText=self.cancelButton
  self:dispatchEvent(e)
end

if (self.b1Button and self.b1Button:hitTestPoint(event.x,event.y)) then
  self:removeFromParent()

  local e=Event.new("complete")
  e.text=self.inputbox:getText()
  e.buttonIndex=1
  e.buttonText=self.button1
  self:dispatchEvent(e)
end

if (self.b2Button and self.b2Button:hitTestPoint(event.x,event.y)) then
  self:removeFromParent()

  local e=Event.new("complete")
  e.text=self.inputbox:getText()
  e.buttonIndex=2
  e.buttonText=self.button2
  self:dispatchEvent(e)
end

event:stopPropagation()

end

--############################################

function TextInputDialog2:show()
stage:addChild(self)
end

--############################################

function TextInputDialog2:hide()
stage:removeChild(self)
end

--############################################

function TextInputDialog2:getText()
return self.inputbox:getText()
end

--############################################

function TextInputDialog2:setText(text)
self.inputbox:setText(text)
end

--############################################

function TextInputDialog2:setSecureInput(secure)
self.secure=secure
self.inputbox:PasswordField(secure)
end

--############################################

function TextInputDialog2:isSecureInput()
return self.secure
end

--############################################

function TextInputDialog2:setInputType(type)
-- Ignore for now
end

--############################################

function TextInputDialog2:getInputType()
return TextInputDialog2.TEXT
end
