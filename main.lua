--[[
    Part of "S50's Intro to Game Development"
    Lecture 0
    
    Implementation of retro game "Pong".
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
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

    -- Loads a new font to globally change the font used by love2d.
    smallFont = love.graphics.newFont("font.ttf", 8)

    -- Set the current font of love2d to the object created with love.graphics.newFont().
    love.graphics.setFont(smallFont)

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

    -- Wipes the screen with the color defined by the RGBA set passed.
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    -- Prints a string into the screen with the position, and alignment passed
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, "center")

    -- Function that draws a rectangle with dimensions and position passed in the parameters.
    -- Render the left side paddle (player 1)
    love.graphics.rectangle("fill", 10, 30, 5, 20)

    -- Render the right side paddle (player 2)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- Render the ball (center)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Finish rendering in virtual resolution
    push:apply("end")
end