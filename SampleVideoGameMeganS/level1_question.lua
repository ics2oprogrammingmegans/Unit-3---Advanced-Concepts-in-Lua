-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Allison
-- Date: May 16, 2017
-- Description: This is the level 1 screen of the game. the charater can be dragged to move
--If character goes off a certain araea they go back to the start. When a user interactes
--with piant a trivia question will come up. they will have a limided time to click on the answer
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )
local physics = require( "physics")


-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_question"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The local variables for this scene
local questionText

local firstNumber
local secondNumber

local answer
local wrongAnswer1
local wrongAnswer2
local wrongAnswer3

local answerText 
local wrongAnswerText1
local wrongAnswerText2
local wrongAnswerText3

local answerPosition = 1
local questionSelect = 1
local bkg
local cover

local X1 = display.contentWidth*2/7
local X2 = display.contentWidth*4/7
local Y1 = display.contentHeight*1/2
local Y2 = display.contentHeight*5.5/7

local userAnswer
local textTouched = false

-- Create the variables for the answers -- 

--- question 1 objects
local circle1
local rectangle1
local pentagon1
local triangle1

-- question 2 objects
local Tri2
local square2
local oval2


-- question 5 objects
local rightAngleTri5
local pentagon2
local oval5
local square5

-- question 6 objects
local rightAngleTri6
local isosceles6
local triangle6

-- question 14 objects
local angles 


-----------------------------------------------------------------------------------------
--LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

--making transition to next scene
local function BackToLevel1() 
    composer.hideOverlay("crossFade", 400 )
  
    ResumeGame()
end 

-----------------------------------------------------------------------------------------
--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerAnswer(touch)
    userAnswer = answerText.text
    
    if (touch.phase == "ended") then

        BackToLevel1( )
    
    end 
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer(touch)
    userAnswer = wrongText1.text
    
    if (touch.phase == "ended") then
        
        BackToLevel1( )
        
        
    end 
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer2(touch)
    userAnswer = wrongText2.text
    
    if (touch.phase == "ended") then

        BackToLevel1( )
        
    end 
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer3(touch)
    userAnswer = wrongText3.text
    
    if (touch.phase == "ended") then

        BackToLevel1( )
        
    end 
end


--adding the event listeners 
local function AddTextListeners ( )
    answerText:addEventListener( "touch", TouchListenerAnswer )
    wrongText1:addEventListener( "touch", TouchListenerWrongAnswer)
    wrongText2:addEventListener( "touch", TouchListenerWrongAnswer2)
    wrongText3:addEventListener( "touch", TouchListenerWrongAnswer3)
end

--removing the event listeners
local function RemoveTextListeners()
    answerText:removeEventListener( "touch", TouchListenerAnswer )
    wrongText1:removeEventListener( "touch", TouchListenerWrongAnswer)
    wrongText2:removeEventListener( "touch", TouchListenerWrongAnswer2)
    wrongText3:removeEventListener( "touch", TouchListenerWrongAnswer3)

end

--local function Answers()

local function DisplayQuestion()

    -- creating random start position in a certian area
    questionSelect = math.random(1,4)

    if (questionSelect == 1) then

        questionText.text = display.newText("Which shape has 5 sides?", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

        -- Display the objects
        circle1.isVisible = true

        -- Set the position of the objects
        circle1.x = X1
        circle1.y = Y1


    elseif (questionSelect == 2) then

        questionText.text = display.newText("What shape is an oval?", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 3) then 

        questionText.text = display.newText("How many vertices does a circle have?", display.contentWidth*1/2, display.contentHeight*1/3, nil, 35 )

    elseif (questionSelect == 4) then

        questionText.text = display.newText(" A circle is a polygon.", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

            -- Display the text objects 
           textObject.isVisible = true
           textObject2.isVisible = true
--[[

    elseif (questionSelect == 5) then

        questionText.text = display.newText(" Click on the triangle ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 6) then   

        questionText.text = display.newText(" Which triangle is isosceles? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 7) then

        questionText.text = display.newText(" How many circles are in this photo? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 8) then

        questionText.text = display.newText(" How many sides does a heptagon have? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 35 )

    elseif (questionSelect == 9) then

        questionText.text = display.newText(" A five-sided polygon is called: ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 10) then

        questionText.text = display.newText(" A polygon that has two more sides than a hexagon is called: ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 25 )

    elseif (questionSelect == 11) then 

        questionText.text = display.newText(" How many more sides than a pentagon does a decagon have? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 25 )

    elseif (questionSelect == 12) then

        questionText.text = display.newText( " A polygon can have as many sides as it likes. ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 30 )

    elseif (questionSelect == 13) then

        questionText.text = display.newText( " A polygon is a plane shape with curved sides. ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 14) then

        questionText.text = display.newText( " Which angle is acute? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 15) then

        questionText.text = display.newText( " Parallel lines are lines that never intercept. ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 16) then

        questionText.text = display.newText( " What is a right angle? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )

    elseif (questionSelect == 17) then

        questionText.text = display.newText( " What do a square and a quadrilateral have in common? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 30 )

    elseif (questionSelect == 18) then

        questionText.text = display.newText( " It is possible to draw a triangle with two right angles. ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 30 )

    elseif (questionSelect == 19) then

        questionText.text = display.newText( " How many pairs of parallel lines does a square have? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 30 )

    elseif (questionSelect == 20) then

        questionText.text = display.newText( " How many vertices does an octagon have? ", display.contentWidth*1/2, display.contentHeight*1/3, nil, 50 )
--]]
    end
end

local function PositionAnswers()

    --creating random start position in a certian area
    answerPosition = math.random(1,3)

    if (answerPosition == 1) then

        answerText.x = X1
        answerText.y = Y1
        
        wrongText1.x = X2
        wrongText1.y = Y1
        
        wrongText2.x = X1
        wrongText2.y = Y2

        wrongText3.x = X2
        wrongText3.y = Y2        

        
    elseif (answerPosition == 2) then

        answerText.x = X1
        answerText.y = Y2
            
        wrongText1.x = X1
        wrongText1.y = Y1
            
        wrongText2.x = X2
        wrongText2.y = Y1

        wrongText3.x = X2
        wrongText3.y = Y2

    elseif (answerPosition == 3) then

        answerText.x = X2
        answerText.y = Y1
            
        wrongText1.x = X1
        wrongText1.y = Y2
            
        wrongText2.x = X1
        wrongText2.y = Y1

        wrongText3.x = X2
        wrongText3.y = Y2
            
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
    --covering the other scene with a rectangle so it looks faded and stops touch from going through
    bkg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    --setting to a semi black colour
    bkg:setFillColor(0,0,0,0.5)

    -----------------------------------------------------------------------------------------
    --making a cover rectangle to have the background fully bolcked where the question is
    cover = display.newRoundedRect(display.contentCenterX, display.contentCenterY, display.contentWidth*0.8, display.contentHeight*0.95, 50 )
    --setting its colour
    cover:setFillColor(96/255, 96/255, 96/255)

    -- create the question text object
    questionText = display.newText("", display.contentCenterX, display.contentCenterY*3/8, Arial, 75)

    -- create the answer text object & wrong answer text objects
    answerText = display.newText("", X1, Y2, Arial, 75)
    answerText.anchorX = 0
    wrongText1 = display.newText("", X2, Y2, Arial, 75)
    wrongText1.anchorX = 0
    wrongText2 = display.newText("", X1, Y1, Arial, 75)
    wrongText2.anchorX = 0
    wrongText3 = display.newText("", X2, Y1, Arial, 75)
    wrongText3.anchorX = 0

    -- Question 1 --

    circle1 = display.newImage("Images/CircleMeganS@2x.png", 0, 0)
    circle1.isVisible = false


    rectangle1 = display.newImage("Images/RectangleMeganS.png", 0, 0)
    rectangle1.isVisible = false

    -- Question 4 --

    -- Create the text for the true and false questions
    textObject = display.newText("True", 0, 0, nil, 50)
    textObject.x = display.contentWidth/2
    textObject.y = display.contentHeight/3
    textObject:setTextColor (1, 1, 0)
    textObject.isVisible = false

    textObject2 = display.newText("False", 0, 0, nil, 50)
    textObject2.x = display.contentWidth/3
    textObject2.y = display.contentHeight/3
    textObject2:setTextColor (1, 1, 0)
    textObject2.isVisible = false

    -----------------------------------------------------------------------------------------

    -- insert all objects for this scene into the scene group
    sceneGroup:insert( bkg )
    sceneGroup:insert( cover )
    sceneGroup:insert( questionText )
    sceneGroup:insert( answerText )
    sceneGroup:insert( wrongText1 )
    sceneGroup:insert( wrongText2 )
    sceneGroup:insert( wrongText3 )

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

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        DisplayQuestion()
        PositionAnswers()
        AddTextListeners()
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
        --parent:resumeGame()
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        RemoveTextListeners()
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
