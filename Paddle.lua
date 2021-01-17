--[[
    Part of "S50's Intro to Game Development"
    Lecture 0
    
    -- Paddle Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

Paddle = Class{}

--[[
    Initializes the Paddle object with the given parameters and sets its initial velocity.
]]

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

--[[
    For apllying the velocity to paddle's position and drawing it on screen.
]]

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end