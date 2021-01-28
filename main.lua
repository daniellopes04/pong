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
    largeFont = love.graphics.newFont("font.ttf", 16)
    scoreFont = love.graphics.newFont("font.ttf", 32)

    -- Set the current font of love2d to the object created with love.graphics.newFont().
    love.graphics.setFont(smallFont)

    -- Creating audio objects that can play at any point in the program.
    sounds = {
        ["paddle_hit"] = love.audio.newSource("sounds/paddle_hit.wav", "static"),
        ["score"] = love.audio.newSource("sounds/score.wav", "static"),
        ["wall_hit"] = love.audio.newSource("sounds/wall_hit.wav", "static"),
        ["game_over"] = love.audio.newSource("sounds/game_over.wav", "static")
    }

    -- Setting up a window with virtual size using "push". 
    -- The virtual resolution will be rendered within the screen, no matter its dimensions. 
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- Initializing player's paddles.
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- Creates ball in the middle of the screen.
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Initializing score variables.
    player1Score = 0
    player2Score = 0

    -- The player which will be serving. 
    servingPlayer = 1

    -- The player who has won the game.
    winningPlayer = 0

    -- Used to transition between different states of the game.
    -- Normally used for beginning, menus, main game, high score list, etc.
    -- In this game, it is used to determine behavior during render and update.
    gameState = "start"

    -- Used to track the game mode set by the player.
    -- The game modes are player vs player = 1, player vs com = 2, com vs com = 3.
    gameMode = 1
end

--[[
    Called by love2d whenever we resize the screen.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Keyboard entry handler, called each frame. The parameter is the key pressed by the user.
]]

function love.keypressed(key)
    if key == "escape" then
        -- Terminate application.
        love.event.quit()
    end

    -- Detects PLAYER vs PLAYER's game choice.
    if key == "1" then
        if gameState == "start" then
            gameState = "serve"
            gameMode = 1
        end
    end

    -- Detects PLAYER vs COM's game choice.
    if key == "2" then
        if gameState == "start" then
            gameState = "serve"
            gameMode = 2
        end
    end

    -- Detects COM vs COM's game choice.
    if key == "3" then
        if gameState == "start" then
            gameState = "serve"
            gameMode = 3
        end
    end
    
    -- Pressing enter during the "start" state will change the game state to "play".
    -- In the "play" state, the ball will move in a random direction.
    if key == "enter" or key == "return" then
        if gameState == "serve" then
            gameState = "play"
        elseif gameState == "done" then
            -- One player has won the game.
            -- Now we restart it giving serve to the player who lost.
            gameState = "serve"

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

--[[
    Called each frame, updates the game state components. The parameter is the elapsed time
    (deltaTime) since the last frame.
]]

function love.update(dt)
    -- Player 1 movement.
    if gameMode == 1 or gameMode == 2 then
        if love.keyboard.isDown("w") then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown("s") then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end
    -- Player 1 simple AI movement
    else
        if ball.y + ball.height < player1.y + player1.height / 2 then
            player1.dy = -PADDLE_SPEED
        elseif ball.y > player1.y + player1.height / 2 then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end
    end
        
    -- Player 2 movement.
    if gameMode == 1 then
        if love.keyboard.isDown("up") then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown("down") then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    -- Player 2 simple AI movement.
    else
        if ball.y + ball.height < player2.y + player2.height / 2 then
            player2.dy = -PADDLE_SPEED
        elseif ball.y > player2.y + player2.height / 2 then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    end

    -- Implements the mechanics of the game.
    if gameState == "serve" then
        -- Changes ball's velocity based on player who last scored.
        ball.dy = math.random(10, 150)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == "play" then
        -- Detect ball collision with paddles.
        -- Reverses the dx if collision is true, slightly increasing it.
        -- Changes dy based on the position.
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- Keep velocity in the same direction, but randomize it.
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            -- Plays the hit sound.
            sounds["paddle_hit"]:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds["paddle_hit"]:play()
        end

        -- Detects upper and lower boundary collision, and reflects the ball.
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds["wall_hit"]:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy

            sounds["wall_hit"]:play()
        end

        -- Detects left and right boundary collision, resets the ball and updates the score.
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            ball:reset()

            -- If the player reached a score of 10, the game is over.
            if player2Score == 10 then
                winningPlayer = 2
                gameState = "done"
                sounds["game_over"]:play()
            else
                sounds["score"]:play()
                gameState = "serve"
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            ball:reset()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = "done"
                sounds["game_over"]:play()
            else
                sounds["score"]:play()
                gameState = "serve"
            end
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
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Player vs. Player press 1.", 0, 20, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Player vs. Com press 2.", 0, 30, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Com vs. Com press 3.", 0, 40, VIRTUAL_WIDTH, "center")

        love.graphics.printf("Controls", 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Player 1: 'w' and 's'", 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Player 2: 'up' and 'down'", 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, "center")
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player ".. tostring(servingPlayer) .."'s serve!", 
            0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to serve.", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "play" then
        --[[ love.graphics.setFont(smallFont)
        if gameMode == 1 then
            love.graphics.printf("Player vs. Player", 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, "center")
        elseif gameMode == 2 then
            love.graphics.printf("Player vs. Com", 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, "center")
        else
            love.graphics.printf("Com vs. Com", 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, "center")
        end ]]
    elseif gameState == "done" then
        love.graphics.setFont(largeFont)
        love.graphics.printf("Player ".. tostring(winningPlayer) .." wins!", 
            0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to restart.", 0, 30, VIRTUAL_WIDTH, "center")
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