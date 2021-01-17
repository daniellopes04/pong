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

-- Speed at which the paddle moves
PADDLE_SPEED = 200

--[[
    Runs when the game starts, only once. It's used to intialize the game state at the beginning
    of program execution.
]]

function love.load()
    -- Use nearest-neighbor filtering on upscaling and downscaling to give it a more low-res look.
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Loads a new font to globally change the font used by love2d.
    smallFont = love.graphics.newFont("font.ttf", 8)

    -- Loads a new font to globally change the font used by love2d.
    scoreFont = love.graphics.newFont("font.ttf", 32)

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

    -- Initializing score variables
    player1Score = 0
    player2Score = 0

    -- Player's paddle positions on Y axis (they only move up and down)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50 

    -- Setting up the window title
    love.window.setTitle("Pong")
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
    (deltaTime) since the last frame.
]]

function love.update(dt)
    -- Player 1 movement
    if love.keyboard.isDown("w") then
        -- Adding negative speed to player 1 paddle.
        -- Negative because Y grows as we go down the screen.
        player1Y = player1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown("s") then
        -- Adding positive speed to player 1 paddle.
        player1Y = player1Y + PADDLE_SPEED * dt
    end
        
    -- Player 2 movement
    if love.keyboard.isDown("up") then
        -- Adding negative speed to player 2 paddle.
        -- Negative because Y grows as we go down the screen.
        player2Y = player2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown("down") then
        -- Adding positive speed to player 2 paddle.
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

--[[
    Called each frame for drawing to the screen after the update or otherwise.
]]

function love.draw()
    -- Begin rendering in virtual resolution
    push:apply("start")

    -- Wipes the screen with the color defined by the RGBA set passed.
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    -- Drawing a welcome text at the top of the screen
    love.graphics.setFont(smallFont)
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, "center")

    -- Draw scores on the left and right center of screen
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Function that draws a rectangle with dimensions and position passed in the parameters.
    -- Render the left side paddle (player 1)
    love.graphics.rectangle("fill", 10, player1Y, 5, 20)

    -- Render the right side paddle (player 2)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- Render the ball (center)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Finish rendering in virtual resolution
    push:apply("end")
end