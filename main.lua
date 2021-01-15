--[[
    Part of "S50's Intro to Game Development"
    Lecture 0
    
    Implementation of retro game "Pong".

    Rules:
    - Each player controls a paddle which must be used to hit the ball into the opponent's 
    player direction.
    - When the player isn't able to hit the ball back, letting it pass beyond its paddle, the 
    opponent scores a point.
    - By getting 10 points, a player wins the match.
]]

-- Push library
push = require "push"

-- Window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Window virtual resolution, rendered within the screen
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
    Runs when the game starts, only once. It's used to intialize the game state at the beginning
    of program execution.
]]

function love.load()
    -- Use nearest-neighbor filtering on upscaling and downscaling to give it a more low-res look.
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Setting up a window using love2d's standard function, setting a size and some flags.
    --[[ love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    }) ]]

    -- Setting up a window with virtual size using "push". 
    -- The virtual resolution will be rendered within the screen, no matter its dimensions. 
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Setting up the window title
    love.window.setTitle("Pong Game")
end

--[[
    Keyboard entry handler, called each frame. The parameter is the key pressed by the user.
]]

function love.keypressed(key)
    if key == "escape" then
        -- Terminate application
        love.event.quit()
    end
end

--[[
    Called each frame, updates the game state components. The parameter is the elapsed time
    (delta) since the last frame.
]]

function love.update(dt)
end

--[[
    Called each frame for drawing to the screen after the update or otherwise.
]]

function love.draw()
    -- Begin rendering in virtual resolution
    push:apply("start")

    love.graphics.printf(
        "Hello Pong!",              -- string to render
        0,                          -- X starting position (0 since it's going to be centered)
        VIRTUAL_HEIGHT / 2 - 6,     -- Y starting position (default font size in love2d is 12)
        VIRTUAL_WIDTH,              -- number of pixels that will be aligned
        "center"                    -- alignment mode ('center', 'rigtht', 'left')
    )

    -- Finish rendering in virtual resolution
    push:apply("end")
end