-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Megan
-- Date: Month Day, Year
-- Description: This is the level 1 screen of the game.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )

-- load physics
local physics = require("physics")

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_screen"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The local variables for this scene
local bkg_image

-- Create the back button to the main menu screen
local backButton

-- Create the lives for the car
local heart1
local heart2
local heart3
local heart4
local heart5

-- To keep track of the hearts the player has
local numLives = 5

-- Create the score
local Score = 0
local scoreObject

-- Create the local variables for the 
local totalSeconds = 60
local secondsLeft = 60
local clockText 
local countDownTimer

-- Create the arrows for the car to move left or right
local rArrow
local lArrow

-- Create the physics for the car
local motionx = 0
local SPEED = 8
local LeftSpeed = -8
local LINEAR_VELOCITY = -100
local GRAVITY = 9

-- Create the walls for the level 1 
local leftW 
local rightW
local topW
local floor

-- Create the car
local Car

-- Create the pylon
local Pylon1
local Pylon2
local Pylon3
local Pylon

local questionsAnswered = 0

-----------------------------------------------------------------------------------------
-- SOUNDS
----------------------------------------------------------------------------------------- 

-- create a sound for when the character collids with the spikes
local crashSound = audio.loadSound("Sounds/Crash.wav")
local crashSoundChannel

-----------------------------------------------------------------------------------------
-- LOCAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- When right arrow is touched, move car right
local function right (touch)
    motionx = SPEED
    Car.xScale = 1
end

-- When left arrow is touched, move car left
local function left (touch)
    motionx = LeftSpeed
    Car.xScale = -1
end

-- Move car horizontally
local function movePlayer (event)
    Car.x = Car.x + motionx
end
 
-- Stop car movement when no arrow is pushed
local function stop (event)
    if (event.phase =="ended") then
        motionx = 0
    end
end

local function AddArrowEventListeners()
    rArrow:addEventListener("touch", right)
    lArrow:addEventListener("touch", left)
end

local function RemoveArrowEventListeners()
    rArrow:removeEventListener("touch", right)
    lArrow:removeEventListener("touch", left)
end

local function AddRuntimeListeners()
    Runtime:addEventListener("enterFrame", movePlayer)
    Runtime:addEventListener("touch", stop )
end

local function RemoveRuntimeListeners()
    Runtime:removeEventListener("enterFrame", movePlayer)
    Runtime:removeEventListener("touch", stop )
end


local function ReplaceCar()

    -- intialize horizontal movement of car
    motionx = 0

    -- add physics body
    physics.addBody( Car, "dynamic", { density=0, friction=0.8, bounce=0, rotation=0 } )

    -- prevent car from being able to tip over
    Car.isFixedRotation = true

    -- add back arrow listeners
    AddArrowEventListeners()

    -- add back runtime listeners
    AddRuntimeListeners()
end

local function MakePylonsVisible()
    Pylon1.isVisible = true
    Pylon2.isVisible = true
    Pylon3.isVisible = true
end

local function MakeHeartsVisible()
    heart1.isVisible = true
    heart2.isVisible = true
    heart3.isVisible = true
    heart4.isVisible = true
    heart5.isVisible = true

end

-- Creating Transition Function to Credits Page
local function MainTransition( )       
    composer.gotoScene( "main_menu", {effect = "zoomInOutFade", time = 1000})
end 


local function UpdateTime()

    -- Decrement the number of seconds
    secondsLeft = secondsLeft - 1

    -- Display the number of seconds left in the clock object 
    clockText.text = "Time Left:" .. secondsLeft

end



-- Function that calls the timer
local function StartTimer()

    -- Create a countdown timer that loops infinitely
    countDownTimer = timer.performWithDelay( 1000, UpdateTime, 0 )

    if (countDownTimer == 0) then
    timer.cancel(countDownTimer)
    
    end
end


local function onCollision( self, event )
    -- for testing purposes
    --print( event.target )        --the first object in the collision
    --print( event.other )         --the second object in the collision
    --print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    --print( event.otherElement )  --the element (number) of the second object which was hit in the collision
    --print( event.target.myName .. ": collision began with " .. event.other.myName )

    if ( event.phase == "began" ) then

        if  (event.target.myName == "Pylon1") or 
            (event.target.myName == "Pylon2") or
            (event.target.myName == "Pylon3") then

            -- add sound effect here
            crashSoundChannel = audio.play(crashSound)

            -- remove runtime listeners that move the car
            RemoveArrowEventListeners()
            RemoveRuntimeListeners()

            -- get the Pylon that the user hit
            Pylon = event.target

            -- stop the character from moving
            motionx = 0

            -- make the character invisible
            Car.isVisible = false

            -- show overlay with math question
            composer.showOverlay( "level1_question", { isModal = true, effect = "fade", time = 100})

            -- Increment questions answered
            questionsAnswered = questionsAnswered + 1
            
        end        

    end
end


local function AddCollisionListeners()
    -- if character collides with ball, onCollision will be called
    Pylon1.collision = onCollision
    Pylon1:addEventListener( "collision" )
    Pylon2.collision = onCollision
    Pylon2:addEventListener( "collision" )
    Pylon3.collision = onCollision
    Pylon3:addEventListener( "collision" )

end

local function RemoveCollisionListeners()

    Pylon1:removeEventListener( "collision" )
    Pylon2:removeEventListener( "collision" )
    Pylon3:removeEventListener( "collision" )

end

local function AddPhysicsBodies()
    --add to the physics engine 

    physics.addBody( leftW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody( rightW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody( topW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody( floor, "static", {density=1, friction=0.3, bounce=0.2} )


    physics.addBody( Pylon1, "static",  {density=0, friction=0, bounce=0} )
    physics.addBody( Pylon2, "static",  {density=0, friction=0, bounce=0} )
    physics.addBody( Pylon3, "static",  {density=0, friction=0, bounce=0} )

end


local function RemovePhysicsBodies()
    
    physics.removeBody( Car )
    physics.removeBody( leftW )
    physics.removeBody( rightW )
    physics.removeBody( topW )
    physics.removeBody( floor ) 
end


-----------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
-----------------------------------------------------------------------------------------

function ResumeGame()

    -- make car visible again
    Car.isVisible = true
    
    if (questionsAnswered > 0) then
        if (Pylon ~= nil) and (Pylon.isBodyActive == true) then
            physics.removeBody( Pylon )
            Pylon.isVisible = false
        end
    end

end


-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    -- Insert the background image
    bkg_image = display.newImageRect("Images/Level1Screen.png", display.contentWidth, display.contentHeight)
    bkg_image.x = display.contentCenterX
    bkg_image.y = display.contentCenterY
    bkg_image.width = display.contentWidth
    bkg_image.height = display.contentHeight

    -- Insert background image into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( bkg_image ) 

    -- Insert the car into the level one screen
    Car = display.newImageRect("Images/MainMenu_Car.png", 0, 0)
    Car.x = display.contentWidth * 1/2
    Car.y = display.contentHeight  * 0.1 / 3
    Car.width = 200
    Car.height = 150
    Car.myName = "Car"

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( Car )


    -- Create the clock text colour and text
    clockText = display.newText("Time Left: ", display.contentWidth*3.3/5, display.contentHeight*2.2/10, nil, 60)
    clockText:setTextColor(0, 0, 0)

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( clockText )

    scoreObject = display.newText("Score: " .. Score, display.contentWidth*4.5/5, display.contentHeight*0.4/10, nil, 50 )
    scoreObject:setTextColor(0, 0, 0)
    scoreObject.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( scoreObject )  

    -- Insert the Hearts
    heart1 = display.newImageRect("Images/heart.png", 80, 80)
    heart1.x = 985
    heart1.y = 100
    heart1.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart1 )

    heart2 = display.newImageRect("Images/heart.png", 80, 80)
    heart2.x = 905
    heart2.y = 100
    heart2.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart2 )

    heart3= display.newImageRect("Images/heart.png", 80, 80)
    heart3.x = 825
    heart3.y = 100
    heart3.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart3 )

    heart4 = display.newImageRect("Images/heart.png", 80, 80)
    heart4.x = 745
    heart4.y = 100
    heart4.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart4 )

    heart5 = display.newImageRect("Images/heart.png", 80, 80)
    heart5.x = 665
    heart5.y = 100
    heart5.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( heart5 )

    Pylon1 = display.newImageRect("Images/Pylon.png", 80, 80)
    Pylon1.x = 150
    Pylon1.y = 650
    Pylon1.isVisible = true
    Pylon1.myName = "Pylon1"

    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( Pylon1 )


    Pylon2 = display.newImageRect("Images/Pylon.png", 80, 80)
    Pylon2.x = 50
    Pylon2.y = 400
    Pylon2.isVisible = true
    Pylon2.myName = "Pylon2"

    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( Pylon2 )
  

    Pylon3 = display.newImageRect("Images/Pylon.png", 80, 80)
    Pylon3.x = 940
    Pylon3.y = 500
    Pylon3.isVisible = true
    Pylon3.myName = "Pylon3"

    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( Pylon3 )

    --Insert the right arrow
    rArrow = display.newImageRect("Images/RightArrowUnpressed.png", 100, 50)
    rArrow.x = display.contentWidth * 9.2 / 10
    rArrow.y = display.contentHeight * 9.5 / 10

     -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rArrow )

    --Insert the left arrow
    lArrow = display.newImageRect("Images/LeftArrowUnpressed.png", 100, 50)
    lArrow.x = display.contentWidth * 7.2 / 10
    lArrow.y = display.contentHeight * 9.5 / 10
   
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( lArrow )

    --WALLS--
    leftW = display.newLine( 0, 0, 0, display.contentHeight)
    leftW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( leftW )

    rightW = display.newLine( 0, 0, 0, display.contentHeight)
    rightW.x = display.contentCenterX * 2
    rightW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rightW )

    topW = display.newLine( 0, 0, display.contentWidth, 0)
    topW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( topW )

    floor = display.newImageRect("Images/Level-1Floor.png", 1024, 100)
    floor.x = display.contentCenterX
    floor.y = display.contentHeight * 1.06
    
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor )

    -- Send the background image to the back layer so all other objects can be on top
    bkg_image:toBack()

-----------------------------------------------------------------------------------------
-- BUTTON WIDGETS
-----------------------------------------------------------------------------------------   

    -- Creating Start Button
    backButton = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*1/8,
            y = display.contentHeight*7.5/8,

            -- Insert the images here
            defaultFile = "Images/BackButtonUnpressed.png", 
            overFile = "Images/BackButtonPressed.png", 

            -- When the button is released, call the Level1 screen transition function
            onRelease = MainTransition         
        } )
    -- Set the scale for the Start button
        backButton:scale( 0.3, 0.3 )
    ----------------------------------------------------------------------------------------

    -- Associating button widgets with this scene
    sceneGroup:insert( backButton ) 

end --function scene:create( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    -----------------------------------------------------------------------------------------
            -- start physics
        physics.start()

        -- set gravity
        physics.setGravity( 0, GRAVITY )


    elseif ( phase == "did" ) then

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.


        -- Start the timer

--        StartTimer()

        -- Keep count of the lives and questions answered

        numLives = 5
        questionsAnswered = 0

        -- make all of the pylons visible
        MakePylonsVisible()

        -- make all lives visible
        MakeHeartsVisible()

        -- add physics bodies to each object
        AddPhysicsBodies()

        -- add collision listeners to objects
        AddCollisionListeners()

        -- create the car, add physics bodies and runtime listeners
        ReplaceCar()

    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        RemoveCollisionListeners()
        RemovePhysicsBodies()
        physics.stop()
        RemoveArrowEventListeners()
        RemoveRuntimeListeners()
    end

end --function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.

end -- function scene:destroy( event )

-----------------------------------------------------------------------------------------
-- EVENT LISTENERS
-----------------------------------------------------------------------------------------

-- Adding Event Listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene

--[[
            if (numLives == 1) then
                -- update hearts
                heart1.isVisible = true
                heart2.isVisible = false
                heart3.isVisible = false 
                heart4.isVisible = false
                heart5.isVisible = false
                timer.performWithDelay(200, ReplaceCar) 
            end

            if (numLives == 2) then 
                -- update hearts
                heart1.isVisible = true 
                heart2.isVisible = true
                heart3.isVisible = false 
                heart4.isVisible = false
                heart5.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter) 
            end

            if (numLives == 3) then 
                -- update hearts
                heart1.isVisible = true 
                heart2.isVisible = true
                heart3.isVisible = true
                heart4.isVisible = false
                heart5.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter) 
            end

            if (numLives == 4) then 
                -- update hearts
                heart1.isVisible = true 
                heart2.isVisible = true
                heart3.isVisible = true
                heart4.isVisible = true
                heart5.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter) 
            end

            else (numLives == 0) 
                -- update hearts
                heart1.isVisible = false
                heart2.isVisible = false
                heart3.isVisible = false
                heart4.isVisible = false
                heart5.isVisible = false

                timer.performWithDelay(200, YouLoseTransition)
            end
        end





local function UpdateTime()

    -- Decrement the number of seconds
    secondsLeft = secondsLeft - 1

    -- Display the number of seconds left in the clock object 
    clockText.text = secondsLeft .. ""

    if ( secondsLeft == 0 ) then
        -- Reset the number of seconds left
        secondsLeft = totalSeconds

        lives = lives - 1

        -- If there are no lives left, play a lose sound, show a you lose image
        -- and cancel the timer remove the third heart by making it invisible

        if (lives == 3) then

            heart3.isVisible = false
            gameOverObject.isVisible = false
            AskQuestion()
        end

        if (lives == 2) then

            heart2.isVisible = false
            gameOverObject.isVisible = false
            AskQuestion()
        end

        if (lives == 1 ) then

            heart1.isVisible = false   
            heart2.isVisible = false
            heart3.isVisible = false 
            timer.cancel(countDownTimer)
            pointsObject.isVisible = false
            heart2.isVisible = false
            heart3.isVisible = false
            gameOverSoundChannel = audio.play(gameOverSound)
            AskQuestion()

            

        end
    end
end

--]]