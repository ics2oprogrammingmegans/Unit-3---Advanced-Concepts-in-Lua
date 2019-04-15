-----------------------------------------------------------------------------------------
--
--splash_screen.lua
-- Created by: Your Name
-- Date: Month Day, Year
-- Description: This is the splash screen of the game. It displays the 
-- company logo that...
-----------------------------------------------------------------------------------------

-- Use Composer Library
local composer = require( "composer" )

-- Name the Scene
sceneName = "splash_screen"

-----------------------------------------------------------------------------------------

-- Create Scene Object
local scene = composer.newScene( sceneName )

----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------
 
-- The local variable for the Platelogo

local Platelogo = display.newImage("Images/CompanyLogo.png", 0, 0 )
local scrollSpeedPlatelogo = -9

-- The local variables for the sound
local CrashSound = audio.loadSound( "Sounds/CrashSound.mp3")
local CrashSoundChannel
--------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
--------------------------------------------------------------------------------------------

-- The function that moves the Platelogo across the screen
local function movePlatelogo()
    Platelogo.x = Platelogo.x + scrollSpeedPlatelogo
    -- change the transparency of the ship every time it moves so that it fades out
    Platelogo.alpha = Platelogo.alpha + 0.01

end

-- The function that will go to the main menu 
local function gotoMainMenu()
    composer.gotoScene( "main_menu" )
end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -- set the background to be black
    display.setDefault( "background", 1, 1, 1  ) 

    -- Move the plate to the middle of the screen form the top
    transition.moveTo( Platelogo, {x = display.contentWidth/2, y = display.contentHeight/2 , time = 1500})

    -- Set the scale of the logo
    Platelogo:scale(0.25, 0.25)

    -- Create the visiblility
    Platelogo.alpha = 1

    -- set the initial x and y position of the Platelogo
    Platelogo.x = display.contentWidth/2
    Platelogo.y = display.contentHeight*1/10

    -- Have the logo fade out 
    transition.fadeOut( Platelogo, { time = 4500 } )

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( Platelogo )

end 

--------------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.views

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    -- Called when the scene is still off screen (but is about to come on screen).
    if ( phase == "will" ) then
       
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- start the splash screen music
        CrashSoundChannel = audio.play( CrashSound )

        -- Call the movePlatelogo function as soon as we enter the frame.
        Runtime:addEventListener("enterFrame", movePlatelogo)

        -- Go to the main menu screen after the given time.
        timer.performWithDelay ( 3000, gotoMainMenu)          
        
    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    -- Called when the scene is on screen (but is about to go off screen).
    -- Insert code here to "pause" the scene.
    -- Example: stop timers, stop animation, stop audio, etc.
    if ( phase == "will" ) then  

    -----------------------------------------------------------------------------------------

    -- Called immediately after scene goes off screen.
    elseif ( phase == "did" ) then
        
        -- stop the jungle sounds channel for this screen
      audio.stop (CrashSoundsChannel) 
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
