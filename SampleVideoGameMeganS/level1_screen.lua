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

-- Create the plyon
local Pylon1
local Pylon2
local Pylon3
local Plyon

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
    Car = display.newImageRect("Images/MainMenu_Car.png", 100, 150)
    Car.x = display.contentWidth * 0.5 / 8
    Car.y = display.contentHeight  * 0.1 / 3
    Car.width = 75
    Car.height = 100
    Car.myName = "Car"

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

--[[
local function onCollision( self, event )
    -- for testing purposes
    --print( event.target )        --the first object in the collision
    --print( event.other )         --the second object in the collision
    --print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    --print( event.otherElement )  --the element (number) of the second object which was hit in the collision
    --print( event.target.myName .. ": collision began with " .. event.other.myName )

    if ( event.phase == "began" ) then

        if  (event.target.myName == "Plyon1") or 
            (event.target.myName == "Plyon2") or
            (event.target.myName == "Plyon3") then

            -- add sound effect here
            crashSoundChannel = audio.play(crashSound)

            -- remove runtime listeners that move the character
            RemoveArrowEventListeners()
            RemoveRuntimeListeners()

            -- remove the character from the display
            display.remove(character)

            -- decrease number of lives
            numLives = numLives - 1

            if (numLives == 1) then
                -- update hearts
                heart1.isVisible = true
                heart2.isVisible = false
                heart3.isVisible = false 
                heart4.isVisible = false
                heart5.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter) 
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

            elseif (numLives == 0) then
                -- update hearts
                heart1.isVisible = false
                heart2.isVisible = false
                heart3.isVisible = false
                heart4.isVisible = false
                heart5.isVisible = false

                timer.performWithDelay(200, YouLoseTransition)
            end
        end

        if  (event.target.myName == "Plyon1") or
            (event.target.myName == "Plyon2") or
            (event.target.myName == "Plyon3") then

            -- play pop sound

            -- get the ball that the user hit
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

        if (event.target.myName == "door") then
            --check to see if the user has answered 5 questions
            if (questionsAnswered == 3) then
                -- after getting 3 questions right, go to the you win screen
                timer.performWithDelay(200, YouWinTransition)   
            end
        end        

    end
end
--]]
local function AddCollisionListeners()
    -- if character collides with ball, onCollision will be called
    Plyon1.collision = onCollision
    Plyon1:addEventListener( "collision" )
    Plyon2.collision = onCollision
    Plyon2:addEventListener( "collision" )
    Plyon3.collision = onCollision
    Plyon3:addEventListener( "collision" )

end

local function AddPhysicsBodies()
    --add to the physics engine

    physics.addBody( Pylon1, "static", { density=1.0, friction=0.3, bounce=0.2 } )
    physics.addBody( Pylon2, "static", { density=1.0, friction=0.3, bounce=0.2 } )
    physics.addBody( Pylon3, "static", { density=1.0, friction=0.3, bounce=0.2 } )    

    physics.addBody(leftW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(rightW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(topW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(floor, "static", {density=1, friction=0.3, bounce=0.2} )


end


local function RemovePhysicsBodies()

    physics.removeBody(Pylon1)
    physics.removeBody(Pylon2)
    physics.removeBody(Pylon3)

    physics.removeBody(leftW)
    physics.removeBody(rightW)
    physics.removeBody(topW)
    physics.removeBody(floor) 
end


-----------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
-----------------------------------------------------------------------------------------

function ResumeGame()

    -- make car visible again
    Car.isVisible = true
    
    if (questionsAnswered > 0) then
        if (Plyon ~= nil) and (Plyon.isBodyActive == true) then
            physics.removeBody(Pylon)
            Plyon.isVisible = false
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

    -- Send the background image to the back layer so all other objects can be on top
    bkg_image:toBack()

    -- Insert background image into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( bkg_image ) 

    -- Insert the Hearts
    heart1 = display.newImageRect("Images/heart.png", 80, 80)
    heart1.x = 50
    heart1.y = 50
    heart1.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart1 )

    heart2 = display.newImageRect("Images/heart.png", 80, 80)
    heart2.x = 130
    heart2.y = 50
    heart2.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart2 )

    heart3= display.newImageRect("Images/heart.png", 80, 80)
    heart3.x = 210
    heart3.y = 50
    heart3.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart3 )

    heart4 = display.newImageRect("Images/heart.png", 80, 80)
    heart4.x = 290
    heart4.y = 50
    heart4.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart4 )

    heart5 = display.newImageRect("Images/heart.png", 80, 80)
    heart5.x = 370
    heart5.y = 50
    heart5.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( heart5 )

    Plyon1 = display.newImageRect("Images/Plyon.png", 80, 80)
    Plyon1.x = 370
    Plyon1.y = 50
    Plyon1.isVisible = true
    
    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( Plyon )
    Plyon1.myName = "Plyon1"

    Plyon2 = display.newImageRect("Images/Plyon.png", 80, 80)
    Plyon2.x = 370
    Plyon2.y = 50
    Plyon2.isVisible = true
    
    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( Plyon2 )
    Plyon2.myName = "Plyon2"

    Plyon3 = display.newImageRect("Images/Plyon.png", 80, 80)
    Plyon3.x = 370
    Plyon3.y = 50
    Plyon3.isVisible = true
    
    -- Insert objects into the scene group in order to ONLY be associated with this scene  
    sceneGroup:insert( Plyon3 )
    Plyon3.myName = "Plyon3"

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

-----------------------------------------------------------------------------------------
-- BUTTON WIDGETS
-----------------------------------------------------------------------------------------   

    -- Creating Start Button
    backButton = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*1/8,
            y = display.contentHeight*7/8,

            -- Insert the images here
            defaultFile = "Images/BackButtonUnpressed.png", 
            overFile = "Images/BackButtonPressed.png", 

            -- When the button is released, call the Level1 screen transition function
            onRelease = MainTransition         
        } )
    -- Set the scale for the Start button
        backButton:scale( 0.5, 0.5 )
    -----------------------------------------------------------------------------------------

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

        numLives = 5
        questionsAnswered = 0

        -- make all lives visible
        MakeHeartsVisible()

        -- add physics bodies to each object
        AddPhysicsBodies()

        -- add collision listeners to objects
        AddCollisionListeners()

        -- create the character, add physics bodies and runtime listeners
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
        display.remove(Car)
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
