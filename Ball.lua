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
    self.dx = 0
    self.dy = 0
end

--[[
    Receives a paddle as argument and returns true or false if their rectangles overlap.
]]
function Ball:collides(paddle)
    -- Checks if the ball's edges are farther to the left or right than the paddle's edges.
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- Checks if the ball's top and bottom edges are higher or lower than the paddle's edges.
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- If the previous aren't true, they're overlapping.
    return true
end

--[[
    For apllying the velocity to ball's position and drawing it on screen.
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--[[
    For drawing the ball on screen.
]]
function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
