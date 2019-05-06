-----------------------------------------------------------------------------------------
--
-- game_level1.lua
-- Created by: Daniel
-- Date: Nov. 22nd, 2014
-- Description: This is the level 1 screen of the game.
-----------------------------------------------------------------------------------------


-- Use Composer Library
local composer = require( "composer" )

-----------------------------------------------------------------------------------------

-- Use Widget Library
local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_screen"

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The background image and soccer ball for this scene
local bkg_image
local soccerball

--the text that displays the question
local questionText 

--the alternate numbers randomly generated
local correctAnswer
local alternateAnswer1
local alternateAnswer2    
local alternateAnswer3   

-- Variables containing the user answer and the actual answer
local userAnswer

-- boolean variables telling me which answer box was touched
local answerboxAlreadyTouched = false
local alternateAnswerBox1AlreadyTouched = false
local alternateAnswerBox2AlreadyTouched = false
local alternateAnswerBox3AlreadyTouched = false

--create textboxes holding answer and alternate answers 
local answerbox
local alternateAnswerBox1
local alternateAnswerBox2
local alternateAnswerBox3

-- create variables that will hold the previous x- and y-positions so that 
-- each answer will return back to its previous position after it is moved
local answerboxPreviousY
local alternateAnswerBox1PreviousY
local alternateAnswerBox2PreviousY
local alternateAnswerBox3PreviousY

local answerboxPreviousX
local alternateAnswerBox1PreviousX
local alternateAnswerBox2PreviousX
local alternateAnswerBox3PreviousX

-- the black box where the user will drag the answer
local userAnswerBoxPlaceholder

-- create the amount of lives so that if the user gets 2 wrong it will transistion to You Lose Screen
local livesCount = 2
local Score = 0

-- sound effects
local correctSound = audio.loadSound("Sounds/Correct.wav")
local correctSoundChannel

local incorrectSound = audio.loadSound("Sounds/WrongBuzzer.mp3")
local incorrectSoundChannel

local backgroundSound = audio.loadSound("Sounds/BackGroundSound.mp3")
local backgroundSoundChannel

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

local function DisplayQuestion()
    local randomNumber1
    local randomNumber2

    --set random numbers
    randomNumber1 = math.random(2, 15)
    randomNumber2 = math.random(2, 15)

    --calculate answer
    correctAnswer = randomNumber1 + randomNumber2

    --change question text in relation to answer
    questionText.text = randomNumber1 .. " + " .. randomNumber2 .. " = " 

    -- put the correct answer into the answerbox
    answerbox.text = correctAnswer

    -- make it possible to click on the answers again
    answerboxAlreadyTouched = false
    alternateAnswerBox1AlreadyTouched = false
    alternateAnswerBox2AlreadyTouched = false
    alternateAnswerBox3AlreadyTouched = false

end

local function DetermineAlternateAnswers()    

        
    -- generate incorrect answer and set it in the textbox
    alternateAnswer1 = correctAnswer + math.random(7, 9)
    alternateAnswerBox1.text = alternateAnswer1

    -- generate incorrect answer and set it in the textbox

    alternateAnswer2 = correctAnswer - math.random(4, 6)
    alternateAnswerBox2.text = alternateAnswer2

    -- generate incorrect answer and set it in the textbox
    alternateAnswer3 = correctAnswer - math.random(1, 3)

    alternateAnswer2 = correctAnswer - math.random(13, 15)
    alternateAnswerBox2.text = alternateAnswer2

    -- generate incorrect answer and set it in the textbox
    alternateAnswer3 = correctAnswer - math.random(4, 6)
    alternateAnswerBox3.text = alternateAnswer3

-------------------------------------------------------------------------------------------
-- RESET ALL X POSITIONS OF ANSWER BOXES (because the x-position is changed when it is
-- placed into the black box)
-----------------------------------------------------------------------------------------
    answerbox.x = display.contentWidth * 0.9
    alternateAnswerBox1.x = display.contentWidth * 0.9
    alternateAnswerBox2.x = display.contentWidth * 0.9
    alternateAnswerBox3.x = display.contentWidth * 0.9


end

local function PositionAnswers()
    local randomPosition

    -------------------------------------------------------------------------------------------
    --ROMDOMLY SELECT ANSWER BOX POSITIONS
    -----------------------------------------------------------------------------------------
    randomPosition = math.random(1,3)

    -- random position 1
    if (randomPosition == 1) then
        -- set the new y-positions of each of the answers
        answerbox.y = display.contentHeight * 0.4

        --alternateAnswerBox2
        alternateAnswerBox3.y = display.contentHeight * 0.85

        --alternateAnswerBox2
        alternateAnswerBox2.y = display.contentHeight * 0.70

        --alternateAnswerBox1
        alternateAnswerBox1.y = display.contentHeight * 0.55

        ---------------------------------------------------------
        --remembering their positions to return the answer in case it's wrong
        alternateAnswerBox1PreviousY = alternateAnswerBox1.y
        alternateAnswerBox2PreviousY = alternateAnswerBox2.y
        answerboxPreviousY = answerbox.y 

    -- random position 2
    elseif (randomPosition == 2) then

        answerbox.y = display.contentHeight * 0.55
        
        --alternateAnswerBox2
        alternateAnswerBox3.y = display.contentHeight * 0.70

        --alternateAnswerBox2
        alternateAnswerBox2.y = display.contentHeight * 0.85

        --alternateAnswerBox1
        alternateAnswerBox1.y = display.contentHeight * 0.4

        --remembering their positions to return the answer in case it's wrong
        alternateAnswerBox1PreviousY = alternateAnswerBox1.y
        alternateAnswerBox2PreviousY = alternateAnswerBox2.y
        answerboxPreviousY = answerbox.y 

    -- random position 3
     elseif (randomPosition == 3) then
        answerbox.y = display.contentHeight * 0.4

        --alternateAnswerBox2
        alternateAnswerBox3.y = display.contentHeight * 0.70

        --alternateAnswerBox2
        alternateAnswerBox2.y = display.contentHeight * 0.55

        --alternateAnswerBox1
        alternateAnswerBox1.y = display.contentHeight * 0.85

        --remembering their positions to return the answer in case it's wrong
        alternateAnswerBox1PreviousY = alternateAnswerBox1.y
        alternateAnswerBox2PreviousY = alternateAnswerBox2.y
        alternateAnswerBox3PreviousY = alternateAnswerBox3.y
        answerboxPreviousY = answerbox.y 
    end
end


-- Transitioning Function to YouWin screen
local function YouWinTransitionLevel1( )
    composer.gotoScene("you_win", {effect = "fade", time = 500})
end

-- Transitioning Function to YouLose screen
local function YouLoseTransitionLevel1( )
    composer.gotoScene("you_lose", {effect = "fade", time = 500})
end

-- Function to Restart Level 1
local function RestartLevel1()
    DisplayQuestion()
    DetermineAlternateAnswers()
    PositionAnswers()    
end


local function CheckUserAnswerInput()

    if (Score == 3) then

        -- after getting 3 questions right, go to the you win screen
        timer.performWithDelay(200, YouWinTransition)

        if (livesCount == 0) then
            -- if the user gets 2 questions wrong, it will go to the you lose screen
            timer.performWithDelay(200, YouLoseTransition)

        else
            RestartLevel1()

        end   
    end
end



        YouWinTransitionLevel1()

    if (livesCount == 0) then

        YouLoseTransitionLevel1()

        else 
            timer.performWithDelay(1600, RestartLevel1) 
        
        end
    end
end

 

local function TouchListenerAnswerbox(touch)
    --only work if none of the other boxes have been touched
    if (alternateAnswerBox1AlreadyTouched == false) and 
        (alternateAnswerBox2AlreadyTouched == false) and
        (alternateAnswerBox3AlreadyTouched == false) then

        if (touch.phase == "began") then

            --let other boxes know it has been clicked
            answerboxAlreadyTouched = true

        --drag the answer to follow the mouse
        elseif (touch.phase == "moved") then
            
            answerbox.x = touch.x
            answerbox.y = touch.y

        -- this occurs when they release the mouse
        elseif (touch.phase == "ended") then

            answerboxAlreadyTouched = false

              -- if the number is dragged into the userAnswerBox, place it in the center of it
            if (((userAnswerBoxPlaceholder.x - userAnswerBoxPlaceholder.width/2) < answerbox.x ) and
                ((userAnswerBoxPlaceholder.x + userAnswerBoxPlaceholder.width/2) > answerbox.x ) and 
                ((userAnswerBoxPlaceholder.y - userAnswerBoxPlaceholder.height/2) < answerbox.y ) and 
                ((userAnswerBoxPlaceholder.y + userAnswerBoxPlaceholder.height/2) > answerbox.y ) ) then

                -- setting the position of the number to be in the center of the box
                answerbox.x = userAnswerBoxPlaceholder.x
                answerbox.y = userAnswerBoxPlaceholder.y
                userAnswer = correctAnswer
                Score = Score + 1

                -- add a score to keep count how many answer the user gets right
                Score = Score + 1

                -- play correct sound when the user gets the answer right
                correctSoundChannel = audio.play(correctSound)

                -- call the function to check if the user's input is correct or not
                CheckUserAnswerInput()

            --else make box go back to where it was
            else
                answerbox.x = answerboxPreviousX
                answerbox.y = answerboxPreviousY
            end
        end
    end                
end 

local function TouchListenerAnswerBox1(touch)
    --only work if none of the other boxes have been touched
    if (answerboxAlreadyTouched == false) and 
        (alternateAnswerBox2AlreadyTouched == false) and
        (alternateAnswerBox3AlreadyTouched == false) then

        if (touch.phase == "began") then
            --let other boxes know it has been clicked
            alternateAnswerBox1AlreadyTouched = true
            
        --drag the answer to follow the mouse
        elseif (touch.phase == "moved") then
            alternateAnswerBox1.x = touch.x
            alternateAnswerBox1.y = touch.y

        elseif (touch.phase == "ended") then
            alternateAnswerBox1AlreadyTouched = false

            -- if the box is in the userAnswerBox Placeholder  go to center of placeholder
            if (((userAnswerBoxPlaceholder.x - userAnswerBoxPlaceholder.width/2) < alternateAnswerBox1.x ) and 
                ((userAnswerBoxPlaceholder.x + userAnswerBoxPlaceholder.width/2) > alternateAnswerBox1.x ) and 
                ((userAnswerBoxPlaceholder.y - userAnswerBoxPlaceholder.height/2) < alternateAnswerBox1.y ) and 
                ((userAnswerBoxPlaceholder.y + userAnswerBoxPlaceholder.height/2) > alternateAnswerBox1.y ) ) then

                alternateAnswerBox1.x = userAnswerBoxPlaceholder.x
                alternateAnswerBox1.y = userAnswerBoxPlaceholder.y

                userAnswer = alternateAnswer1

                -- lose a life to keep track how many t=answers the user gets wrong
                livesCount = livesCount - 1

                -- play incorrect sound
                incorrectSoundChannel = audio.play(incorrectSound)

                -- call the function to check if the user's input is correct or not
                CheckUserAnswerInput()

            --else make box go back to where it was
            else
                alternateAnswerBox1.x = alternateAnswerBox1PreviousX
                alternateAnswerBox1.y = alternateAnswerBox1PreviousY
            end
        end
    end
end 

local function TouchListenerAnswerBox2(touch)
    --only work if none of the other boxes have been touched
    if (answerboxAlreadyTouched == false) and 
        (alternateAnswerBox3AlreadyTouched == false) and
        (alternateAnswerBox1AlreadyTouched == false) then

        if (touch.phase == "began") then
            --let other boxes know it has been clicked
            alternateAnswerBox2AlreadyTouched = true
            
        elseif (touch.phase == "moved") then
            --dragging function
            alternateAnswerBox2.x = touch.x
            alternateAnswerBox2.y = touch.y

        elseif (touch.phase == "ended") then
            alternateAnswerBox2AlreadyTouched = false

            -- if the box is in the userAnswerBox Placeholder  go to center of placeholder
            if (((userAnswerBoxPlaceholder.x - userAnswerBoxPlaceholder.width/2) < alternateAnswerBox2.x ) and 
                ((userAnswerBoxPlaceholder.x + userAnswerBoxPlaceholder.width/2) > alternateAnswerBox2.x ) and 
                ((userAnswerBoxPlaceholder.y - userAnswerBoxPlaceholder.height/2) < alternateAnswerBox2.y ) and 
                ((userAnswerBoxPlaceholder.y + userAnswerBoxPlaceholder.height/2) > alternateAnswerBox2.y ) ) then

                alternateAnswerBox2.x = userAnswerBoxPlaceholder.x
                alternateAnswerBox2.y = userAnswerBoxPlaceholder.y

                userAnswer = alternateAnswer2
                livesCount = livesCount - 1

                -- lose a life to keep track how many answers the user gets wrong
                livesCount = livesCount - 1

                -- play incorrect sound
                incorrectSoundChannel = audio.play(incorrectSound)

                -- call the function to check if the user's input is correct or not
                CheckUserAnswerInput()

            --else make box go back to where it was
            else
                alternateAnswerBox2.x = alternateAnswerBox2PreviousX
                alternateAnswerBox2.y = alternateAnswerBox2PreviousY
            end
        end
    end
end 

local function TouchListenerAnswerBox3(touch)
    --only work if none of the other boxes have been touched
    if (answerboxAlreadyTouched == false) and 
        (alternateAnswerBox2AlreadyTouched == false) and
        (alternateAnswerBox1AlreadyTouched == false) then

        if (touch.phase == "began") then
            --let other boxes know it has been clicked
            alternateAnswerBox3AlreadyTouched = true
            
        elseif (touch.phase == "moved") then
            --dragging function
            alternateAnswerBox3.x = touch.x
            alternateAnswerBox3.y = touch.y

        elseif (touch.phase == "ended") then
            alternateAnswerBox3AlreadyTouched = false

            -- if the box is in the userAnswerBox Placeholder  go to center of placeholder
            if (((userAnswerBoxPlaceholder.x - userAnswerBoxPlaceholder.width/2) < alternateAnswerBox3.x ) and 
                ((userAnswerBoxPlaceholder.x + userAnswerBoxPlaceholder.width/2) > alternateAnswerBox3.x ) and 
                ((userAnswerBoxPlaceholder.y - userAnswerBoxPlaceholder.height/2) < alternateAnswerBox3.y ) and 
                ((userAnswerBoxPlaceholder.y + userAnswerBoxPlaceholder.height/2) > alternateAnswerBox3.y ) ) then

                alternateAnswerBox3.x = userAnswerBoxPlaceholder.x
                alternateAnswerBox3.y = userAnswerBoxPlaceholder.y
                userAnswer = alternateAnswer3
                livesCount = livesCount - 1

                -- the player loses a life if they get the answer the wrong answer
                livesCount = livesCount - 1

                -- play incorrect sound
                incorrectSoundChannel = audio.play(incorrectSound)

                -- call the function to check if the user's input is correct or not
                CheckUserAnswerInput()

            --else make box go back to where it was
            else
                alternateAnswerBox3.x = alternateAnswerBox3PreviousX
                alternateAnswerBox3.y = alternateAnswerBox3PreviousY
            end
        end
    end
end 

-- Function that Adds Listeners to each answer box
local function AddAnswerBoxEventListeners()
    answerbox:addEventListener("touch", TouchListenerAnswerbox)
    alternateAnswerBox1:addEventListener("touch", TouchListenerAnswerBox1)
    alternateAnswerBox2:addEventListener("touch", TouchListenerAnswerBox2)
    alternateAnswerBox3:addEventListener("touch", TouchListenerAnswerBox3)
end 

-- Function that Removes Listeners to each answer box
local function RemoveAnswerBoxEventListeners()
    answerbox:removeEventListener("touch", TouchListenerAnswerbox)
    alternateAnswerBox1:removeEventListener("touch", TouchListenerAnswerBox1)
    alternateAnswerBox2:removeEventListener("touch", TouchListenerAnswerBox2)
    alternateAnswerBox3:removeEventListener("touch", TouchListenerAnswerBox3)
end 

----------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
----------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    ----------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------
    --Inserting backgroud image and lives
    ----------------------------------------------------------------------------------

    -- Insert the background image
    bkg_image = display.newImageRect("Images/Game Screen.png", 2048, 1536)
    bkg_image.anchorX = 0
    bkg_image.anchorY = 0
    bkg_image.width = display.contentWidth
    bkg_image.height = display.contentHeight

    --the text that displays the question
    questionText = display.newText( "" , 0, 0, nil, 120)
    questionText.x = display.contentWidth * 0.3
    questionText.y = display.contentHeight * 0.9

    -- create the soccer ball and place it on the scene
    soccerball = display.newImageRect("Images/soccerball.png", 60, 60, 0, 0)
    soccerball.x = display.contentWidth*0.385
    soccerball.y = display.contentHeight * 12/20

    -- boolean variables stating whether or not the answer was touched
    answerboxAlreadyTouched = false
    alternateAnswerBox1AlreadyTouched = false
    alternateAnswerBox2AlreadyTouched = false
    alternateAnswerBox3AlreadyTouched = false

    --create answerbox alternate answers and the boxes to show them
    answerbox = display.newText("", display.contentWidth * 0.9, 0, nil, 100)

    alternateAnswerBox1 = display.newText("", display.contentWidth * 0.9, 0, nil, 120)
    alternateAnswerBox2 = display.newText("", display.contentWidth * 0.9, 0, nil, 120)
    alternateAnswerBox3 = display.newText("", display.contentWidth * 0.9, 0, nil, 120)

    -- set the x positions of each of the answer boxes
    answerboxPreviousX = display.contentWidth * 0.9
    alternateAnswerBox1PreviousX = display.contentWidth * 0.9
    alternateAnswerBox2PreviousX = display.contentWidth * 0.9
    alternateAnswerBox3PreviousX = display.contentWidth * 0.9

    -- the black box where the user will drag the answer
    userAnswerBoxPlaceholder = display.newImageRect("Images/userAnswerBoxPlaceholder.png",  130, 130, 0, 0)
    userAnswerBoxPlaceholder.x = display.contentWidth * 0.6
    userAnswerBoxPlaceholder.y = display.contentHeight * 0.9

    ----------------------------------------------------------------------------------
    --adding objects to the scene group
    ----------------------------------------------------------------------------------

    sceneGroup:insert( bkg_image ) 
    sceneGroup:insert( questionText ) 
    sceneGroup:insert( userAnswerBoxPlaceholder )
    sceneGroup:insert( answerbox )
    sceneGroup:insert( alternateAnswerBox1 )
    sceneGroup:insert( alternateAnswerBox2 )
    sceneGroup:insert( alternateAnswerBox3 )
    sceneGroup:insert( soccerball )

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

    elseif ( phase == "did" ) then

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

        -- Play background sound
        backgroundSoundChannel = audio.play(backgroundSound)

        RestartLevel1()
        AddAnswerBoxEventListeners() 

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
        audio.stop()
        RemoveAnswerBoxEventListeners()
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
end

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