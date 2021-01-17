--[[
    Part of "S50's Intro to Game Development"
    Lecture 0
    
    -- Ball Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

Ball = Class{}

--[[
    Initializes the Ball object with the given parameters and randomly generates its velocity.
]]

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- Sets a velocity for the ball
    -- math.random(2) == 1 and 100 or -100  equals to math.random(2) == 1 ? 100 : -100.
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50) * 1.5
end

--[[
    Places the ball in the middle of the screen with an inital random velocity.
]]

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50) * 1.5
end

--[[
    For apllying the velocity to ball's position and drawing it on screen.
]]

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
