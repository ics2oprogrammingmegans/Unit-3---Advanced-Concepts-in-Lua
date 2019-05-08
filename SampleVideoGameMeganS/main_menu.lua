-----------------------------------------------------------------------------------------
-- main_menu.lua
-- Created by: Megan
-- Date: Month Day, Year
-- Description: This is the main menu, displaying the credits, instructions & play buttons.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Library
local composer = require( "composer" )

-----------------------------------------------------------------------------------------

-- Use Widget Library
local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "main_menu"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

local bkg_image
local startButton
local creditsButton
local instructionButton

-- Animation for the main menu screen

local Car 

-- The variables for the trees
local Tree_1
local Tree_2

-- The variables for the rocks
local Rock_1
local Rock_2


-- The variables for the Mute and Unmute buttons
local MuteButton
local UnmuteButton

-- Create a local variable for the cloud
local Cloud

-- Create a local variable for the sun
local Sun
-----------------------------------------------------------------------------------------
-- SOUNDS
-----------------------------------------------------------------------------------------

local backgroundSound = audio.loadSound("Sounds/Race-track.wav")
local backgroundSoundChannel

-----------------------------------------------------------------------------------------
-- GLOBAL VARIABLES
-----------------------------------------------------------------------------------------
soundOn = true

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

-- Creating Transition Function to Credits Page
local function CreditsTransition( )       
    composer.gotoScene( "credits_screen", {effect = "slideUp", time = 500})
end 

-----------------------------------------------------------------------------------------

-- Creating Transition to Level1 Screen
local function Level1ScreenTransition( )
    composer.gotoScene( "level1_screen", {effect = "zoomInOutFade", time = 1000})
end    

-----------------------------------------------------------------------------------------

-- Creating Transition to Instuctions Screen
local function InstructionTransition( )
    composer.gotoScene( "instruction_screen", {effect = "slideUp", time = 1000})
end    

-- Creating the mute/unmute buttons
local function Mute( touch )
    if (touch.phase == "ended") then
        -- pause the sound
        audio.pause(backgroundSound)
        -- set the boolean variable to be false (sound is now muted)
        soundOn = false
        -- hide the mute button visible 
        MuteButton.isVisible = false
        -- make the unmute button visible
        UnmuteButton.isVisible = true
    end
end

local function Unmute( touch )
    if (touch.phase == "ended") then
        -- play the sound
        audio.resume(backgroundSound)
        -- set the boolean variable to be false (sound is now muted)
        soundOn = true
        -- make the unmute button visible
        UnmuteButton.isVisible = false
        -- hide the mute button visible 
        MuteButton.isVisible = true

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
    -- BACKGROUND IMAGE & STATIC OBJECTS
    -----------------------------------------------------------------------------------------


    -- Hide the status bar 
    display.setStatusBar(display.HiddenStatusBar)

    -- Insert the background image and set it to the center of the screen
    bkg_image = display.newImage("Images/MainMenuMeganS.png")
    bkg_image.x = display.contentCenterX
    bkg_image.y = display.contentCenterY
    bkg_image.width = display.contentWidth
    bkg_image.height = display.contentHeight

    -- Insert the car and set the scale
    Car = display.newImage("Images/MainMenu_Car.png")
    Car.x = display.contentWidth*7.7/10
    Car.y = display.contentHeight*3/10
    Car:scale( 0.1, 0.1 )

    -- Insert the mute/unmute
    MuteButton = display.newImageRect("Images/MuteButton.png", 80, 80)
    MuteButton.x = display.contentWidth*1/10
    MuteButton.y = display.contentHeight*9.3/10
    MuteButton.isVisible = true

    UnmuteButton = display.newImageRect("Images/MainMenu_UnmuteButton.png", 80, 80)
    UnmuteButton.x = display.contentWidth*1/10
    UnmuteButton.y = display.contentHeight*9.3/10
    UnmuteButton.isVisible = false  

    Sun = display.newImageRect("Images/MainMenu_Sun.png", 1000, 1000)
    Sun.x = display.contentWidth*9.5/10
    Sun.y = display.contentHeight*2/10

    Tree_1 = display.newImageRect("Images/MainMenu_Tree.png", 110, 110)
    Tree_1.x = display.contentWidth*5/8
    Tree_1.y = display.contentHeight*1/2

    Tree_2 = display.newImageRect("Images/MainMenu_Tree2.png", 130, 130)
    Tree_2.x = display.contentWidth*9.5/10
    Tree_2.y = display.contentHeight*2/3

    Rock_1 = display.newImageRect("Images/MainMenu_Rock.png", 90, 40)
    Rock_1.x = display.contentWidth*6/10
    Rock_1.y = display.contentHeight*2/3

    Rock_2 = display.newImageRect("Images/MainMenu_Rock.png", 70, 40)
    Rock_2.x = display.contentWidth*8.5/10
    Rock_2.y = display.contentHeight*3.7/8

    Cloud = display.newImageRect("Images/MainMenu_Cloud.png", 350, 200)
    Cloud.x = 100
    Cloud.y = 100



    -- Associating display objects with this scene 
    sceneGroup:insert( bkg_image )
    sceneGroup:insert( Car )
    sceneGroup:insert( Sun )
    sceneGroup:insert( Tree_1 )
    sceneGroup:insert( Tree_2 )
    sceneGroup:insert( Cloud )
    sceneGroup:insert( Rock_1 )
    sceneGroup:insert( Rock_2 )

    -- Send the background image to the back layer so all other objects can be on top
    bkg_image:toBack()

    -----------------------------------------------------------------------------------------
    -- BUTTON WIDGETS
    -----------------------------------------------------------------------------------------   

    -- Creating Start Button
    startButton = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*1/8,
            y = display.contentHeight*4/8,

            -- Insert the images here
            defaultFile = "Images/PlayButtonUnpressed.png", 
            overFile = "Images/PlayButtonPressed.png", 

            -- When the button is released, call the Level1 screen transition function
            onRelease = Level1ScreenTransition          
        } )
    -- Set the scale for the Start button
        startButton:scale( 0.55, 0.55 )
    -----------------------------------------------------------------------------------------

    -- Creating Credits Button
    creditsButton = widget.newButton( 
        {
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*1/8,
            y = display.contentHeight*5.25/8,

            -- Insert the images here
            defaultFile = "Images/CreditsButtonUnpressed.png",
            overFile = "Images/CreditsButtonPressed.png",

            -- When the button is released, call the Credits transition function
            onRelease = CreditsTransition
        } ) 
        -- Set the scale for the Credits button
        creditsButton:scale( 0.55, 0.55 )
 -----------------------------------------------------------------------------------------
   
    -- Creating the instructions button
    instructionButton = widget.newButton(
        { 
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*1/8,
            y = display.contentHeight*6.5/8,


            -- Insert the images here
            defaultFile = "Images/InstructionsButtonUnpressed.png",
            overFile = "Images/InstructionsButtonPressed.png",

            -- When the button is released, call the Credits transition function
            onRelease = InstructionTransition
        } ) 
    
         -- Set the scale of the instructions button
         instructionButton:scale( 0.55, 0.55 )
    -----------------------------------------------------------------------------------------

    -- Associating button widgets with this scene
    sceneGroup:insert( startButton )
    sceneGroup:insert( creditsButton )
    sceneGroup:insert( instructionButton )
    sceneGroup:insert( MuteButton )
    sceneGroup:insert( UnmuteButton )
 
    -- INSERT INSTRUCTIONS BUTTON INTO SCENE GROUP

end -- function scene:create( event )   



-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    -- Called when the scene is still off screen (but is about to come on screen).   
    if ( phase == "will" ) then
       
 --       backgroundSoundChannel = audio.play(backgroundSound)  
    -----------------------------------------------------------------------------------------

    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    elseif ( phase == "did" ) then  

        -- Move the cloud
        transition.moveTo( Cloud, {x = 250, y = 100 , time = 3000})

        transition.moveTo( Car, {x = display.contentWidth*7.77/10, y = display.contentHeight*8.7/10 , time = 2000})

        -- Play the background music
        backgroundSoundChannel = audio.play(backgroundSound, {loops = -1})

        -- Add the event listeners
        MuteButton:addEventListener("touch", Mute)
        UnmuteButton:addEventListener("touch", Unmute)


    end

end -- function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        audio.stop(backgroundSoundChannel)

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.

        MuteButton:removeEventListener("touch", Mute)
        UnmuteButton:removeEventListener("touch", Unmute)

    end

end -- function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

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
