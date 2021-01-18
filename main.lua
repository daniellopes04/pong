--[[
    Part of "S50's Intro to Game Development"
    Lecture 0
    
    -- Implementation of retro game "Pong". --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

-- Push library
-- https://github.com/Ulydev/push
push = require "push"

-- Class library
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require "class"

-- Paddle and Ball classes
require "Paddle"
require "Ball"

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

    -- Setting up the window title.
    love.window.setTitle("Pong")

    -- "Seed" the random number generator so we have real random generations.
    -- Uses the current time, since it will vary every time the game starts up.
    math.randomseed(os.time())

    -- Loads a new font to globally change the font used by love2d.
    smallFont = love.graphics.newFont("font.ttf", 8)

    -- Loads a new font to globally change the font used by love2d.
    scoreFont = love.graphics.newFont("font.ttf", 32)

    -- Set the current font of love2d to the object created with love.graphics.newFont().
    love.graphics.setFont(smallFont)

    -- Setting up a window with virtual size using "push". 
    -- The virtual resolution will be rendered within the screen, no matter its dimensions. 
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Initializing score variables.
    player1Score = 0
    player2Score = 0

    -- Initializing player's paddles.
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- The player which will be serving. 
    servingPlayer = 1

    -- Creates ball in the middle of the screen.
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Used to transition between different states of the game.
    -- Normally used for beginning, menus, main game, high score list, etc.
    -- In this game, it is used to determine behavior during render and update.
    gameState = "start"
end

--[[
    Keyboard entry handler, called each frame. The parameter is the key pressed by the user.
]]

function love.keypressed(key)
    if key == "escape" then
        -- Terminate application.
        love.event.quit()
    
    -- Pressing enter during the "start" state will change the game state to "play".
    -- In the "play" state, the ball will move in a random direction.
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
        end
    end
end

--[[
    Called each frame, updates the game state components. The parameter is the elapsed time
    (deltaTime) since the last frame.
]]

function love.update(dt)
    -- Player 1 movement
    if love.keyboard.isDown("w") then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
        
    -- Player 2 movement
    if love.keyboard.isDown("up") then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- Implements the mechanics of the game.
    if gameState == "serve" then
        -- Changes ball's velocity based on player who last scored.
        ball.dy = math.random(-50, 50)
        if(servingPlayer == 1) then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == "play" then
        -- Detect ball collision with paddles.
        -- Reverses the dx if collision is true, slightly increasing it.
        -- Changes dy based on the position 
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- Keep velocity in the same direction, but randomize it.
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Detects upper and lower boundary collision, and reflects the ball.
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

        -- Detects left and right boundary collision, resets the ball and updates the score.
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            gameState = "serve"
            ball:reset()
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            gameState = "serve"
            ball.reset()
        end
    end

    -- Updates the ball's position
    if gameState == "play" then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
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

    if gameState == "start" then
        love.graphics.printf("Hello Start State!", 0, 20, VIRTUAL_WIDTH, "center")
    else
        love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, "center")
    end

    -- Draw scores on the left and right center of screen
    displayScore()

    -- Render paddles and ball
    player1:render()
    player2:render()
    ball:render()

    -- Shows the game's FPS.
    displayFPS()

    -- Finish rendering in virtual resolution
    push:apply("end")
end

--[[
    Simple function for rendering the scores.
]]
function displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end

--[[
    Renders the current FPS.
]]

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("FPS - "..tostring(love.timer.getFPS()), 10, 10)
end