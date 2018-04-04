-----------------------------------------------------------------------------------------
-- Title: MathQuiz
-- Name: Avery Mack
-- Course: ICS20/3C
-- This program is a math game that asks division, multiplicaton, addition and subtraction questions. 
-- 
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- hide the status bar

-- sets the background colour
display.setDefault("background", 70/255, 16/255, 71/255)

-----------------------------------------------------------------------------------
-- LOCAL VARIBALES
-----------------------------------------------------------------------------------

-- create local variables 
local questionObject
local correctObject
local incorrectObject
local correctAnswerObject
local NumericTextField
local randomNumber1
local randomNumber2
local userAnswer
local correctAnswer
local randomOperator
local points = 0
local pointsObject 

-- varibles for the timer
local totalSeconds = 11
local secondsLeft = 11
local clockText
local countDownTimer

local lives = 3
local heart1
local heart2
local heart3

-- local varibale for the sounds
local gameOverSound 
local incorrectSound
local correctSound 
-- Setting a varibale to an mp3
local gameOverSoundChannel
local incorrectSounsChannel
local correctSoundChannel

---------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
---------------------------------------------------------------------------------

-- get rid of the status bar
display.setStatusBar(display.HiddenStatusBar)

local function AskQuestion()
	-- generate 2 random numbers between a max. and a min. number 
	randomNumber1 = math.random (10, 20)
	randomNumber2 = math.random (10, 20)
    randomOperator = math.random (1, 4)


	-- create question in text object 
	if randomOperator == 1 then 
		randomNumber1 = math.random (1, 20)
		randomNumber2 = math.random (1, 20)
		correctAnswer = randomNumber1 + randomNumber2
		questionObject.text = randomNumber1 .. " + " .. randomNumber2 .. 	" = " 
	  

	elseif randomOperator == 2 then 
		randomNumber1 = math.random (1, 20)
		randomNumber2 = math.random (1, 20)
		correctAnswer = randomNumber1 - randomNumber2
		questionObject.text = randomNumber1 .. " - " .. randomNumber2 ..  " = " 
		if (correctAnswer < 0) then
			correctAnswer = randomNumber2 - randomNumber1
		questionObject.text = randomNumber2 .. " - " .. randomNumber1 ..  " = " 
	end


	elseif randomOperator == 3 then
		randomNumber1 = math.random (1, 10)
		randomNumber2 = math.random (1, 10)
		correctAnswer = randomNumber1 * randomNumber2
		questionObject.text = randomNumber1 .. " * " .. randomNumber2 .. " = "
    


	elseif randomOperator == 4 then
		randomNumber1 = math.random (1, 100) 
		randomNumber1 = math.random (1, 100)
		correctAnswer = randomNumber1 / randomNumber2
		questionObject.text = randomNumber1 .. " / " .. randomNumber2 .. " = "
	end 
end


local function UpdateHearts()
	if (lives == 3) then 
		heart1.isVisible = true 
		heart2.isVisible = true 
		heart3.isVisible = true 
		gameOver.isVisible = false
	elseif (lives == 2) then 
		heart1.isVisible = true 
		heart2.isVisible = true 
		heart3.isVisible = false
		gameOver.isVisible = false
	elseif (lives == 1) then 
		heart1.isVisible = true 
		heart2.isVisible = false
		heart3.isVisible = false
		gameOver.isVisible = false
	elseif (lives == 0) then 
		gameOver.isVisible = true
		numericField.isVisible = false 
		clockText.isVisible = false 
		gameOverSoundChannel = audio.play(gameOverSound)
	end 
end 


local function UpdatePoints()
	if (points == 2) then
		youWin.isVisible = true 
	end
end 


local function UpdateTime()

	-- decrement the number of seconds 
	secondsLeft = secondsLeft - 1

	-- display the number of seconds left in the clock object
	clockText.text = secondsLeft .. ""

	if (secondsLeft == 0) then 
		-- reset the number of seconds left 
		secondsLeft = totalSeconds
		lives = lives - 1 
		UpdateHearts()
		AskQuestion()
	end 
end 





-- function that calls the timer 
local function StartTimer()
	-- create a countdown timer that loops infinetly 
	countDownTimer = timer.performWithDelay( 1000, UpdateTime, 0)
end 


local function HideCorrect()
	correctObject.isVisible = false 
	incorrectObject.isVisible = false 
	AskQuestion()
end 

local function HideIncorrect()
	incorrectObject.isVisible = false 
	correctObject.isVisible = false 
	AskQuestion()
end 

local function NumericFieldListener(event)
	-- User begins editing "numericField"
	if ( event.phase == "began" ) then 

		
		elseif event.phase == "submitted" then

			-- when the answer is submitted (enter key is pressed) set user input to user's answer
			userAnswer = tonumber(event.target.text)

			-- if the users answer and the correct answer are the same:
			if (userAnswer == correctAnswer) then
				correctSoundChannel = audio.play(correctSound)
				correctObject.isVisible = true 
				timer.performWithDelay(1500, HideCorrect)
				points = points + 1
				pointsObject.text = points 
				UpdatePoints()
				secondsLeft = totalSeconds 
			else incorrectObject.isVisible = true 
				incorrectSoundChannel = audio.play(incorrectSound)
				correctAnswerObject.isVisible = true
				timer.performWithDelay(1500, HideIncorrect)
				lives = lives - 1
				secondsLeft = totalSeconds
				UpdateHearts()
			end	
			if (points == 5) then 
				youWin.isVisible = true 
			end 	
		-- clear text field 
		event.target.text = ""

	end 
end


-----------------------------------------------------------------------------------
-- OBJECT CREATION
-----------------------------------------------------------------------------------

-- displays a question and sets the color
questionObject = display.newText( "", display.contentWidth/3, display.contentHeight/3, nil, 100) 
questionObject:setTextColor(0/255, 246/255, 0/255)

-- display a points object and set the colour
pointsObject = display.newText( "0 ", 900, 700, nil, 100)
pointsObject:setTextColor(255/255, 255/255, 255/255)
--pointsObject.text = " 0 "

-- create the correct text object and make it invisible 
correctObject = display.newText( "Correct!", display.contentWidth/2, display.contentHeight*2/3, nil, 50)
correctObject:setTextColor(0/255, 246/255, 0/255)
correctObject.isVisible = false 

-- create the incorrect text object and make it invisible
incorrectObject = display.newText( "Incorrect!", display.contentWidth/2, display.contentHeight*2/3, nil, 50)
incorrectObject:setTextColor(225/255, 0/255, 0/255)
incorrectObject.isVisible = false 

-- create a text object that tells the user what the correct answer was 
correctAnswerObject = display.newText( " The correct answer was ", display.contentWidth/2, display.contentHeight*2.5/3, nil, 50)
correctAnswerObject:setTextColor(255/255, 255/255, 255/255)
correctAnswerObject.isVisible = false 

-- create numeric field 
numericField = native.newTextField( 675, 263, 200, 100)
numericField.inputType = "number"

-- add the event listener for the numeric field 
numericField:addEventListener( "userInput", NumericFieldListener )

-- create the lives that display on the screen
heart1 = display.newImageRect("Images/heart.png", 100, 100)
heart1.x = display.contentWidth * 7/8
heart1.y = display.contentHeight * 1/7

heart2 = display.newImageRect("Images/heart.png", 100, 100)
heart2.x = display.contentWidth * 6/8
heart2.y = display.contentHeight * 1/7

heart3 = display.newImageRect("Images/heart.png", 100, 100)
heart3.x = display.contentWidth * 5/8
heart3.y = display.contentHeight * 1/7

gameOver = display.newImageRect("Images/gameOver.png", display.contentWidth, display.contentHeight)
gameOver.anchorX = 0
gameOver.anchorY = 0 
gameOver.isVisible = false 

youWin = display.newImageRect("Images/youWin.png", display.contentWidth, display.contentHeight)
youWin.anchorX = 0
youWin.anchorY = 0
youWin.isVisible = false

gameOverSound = audio.loadSound("sounds/gameOver.mp3")
incorrectSound = audio.loadSound ("sounds/incorrect.mp3")
correctSound = audio.loadSound("sounds/correct.mp3")

-- create the clock text
clockText = display.newText("", display.contentWidth/2, display.contentHeight/2, nil, 50)
clockText:setTextColor (230/255, 230/255, 0/255)

----------------------------------------------------------------------------------
-- FUNCTION CALLS
----------------------------------------------------------------------------------

-- call the function to ask the question
AskQuestion()
StartTimer()






