--[[
    Part of "S50's Intro to Game Development"
    Lecture 0
    
    Implementation of retro game "Pong".

    Rules:
    - Each player controls a paddle which must be used to hit the ball into the opponent's player
    direction.
    - When the player isn't able to hit the ball back, letting it pass beyond its paddle, the opponent
    scores a point.
    - By getting 10 points, a player wins the match.
]]

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[
    Runs when the game starts, only once. It's used to intialize the game state at the beginning
    of program execution.
]]

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

--[[
    Called each frame, updates the game state components. The parameter will be the elapsed time
    (delta) since the last frame.
]]

function love.update(dt)

end

--[[
    Called each frame for drawing to the screen after the update.
]]

function love.draw()
    love.graphics.printf(
        'Hello Pong!',          -- string to render
        0,                      -- X starting position (0 since it's going to be centered)
        WINDOW_HEIGHT / 2 - 6,  -- Y starting position (default font size in love2d is 12)
        WINDOW_WIDTH,           -- number of pixels that will be aligned
        'center'                -- alignment mode ('center', 'rigtht', 'left')
    )
end
