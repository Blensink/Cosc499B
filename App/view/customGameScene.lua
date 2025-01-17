--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local session = require( "model.sessionModel" )
local analytics = require( "model.analyticsModel" )
local settings = require( "model.settingsModel" )
local strings = require("constants.strings")

local backButtonGroup
local createButtonGroup
local playButtonGroup

local backButton
local createButton
local playButton

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
-- local forward references should go here

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--- Composer functions.
-- Standard event handlers that are called by the Composer API when changing scenes.
-- @section composer

--- Called when the scene's view does not exist.
-- @tparam event event Event fired by the composer API.
function scene:create( event )
	local sceneGroup = self.view

	-----------------------------------------------------------------------------
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	-----------------------------------------------------------------------------
	local background = display.newImageRect( "img/questionBackground.png", display.contentHeight,
    display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.alpha = 0.25
	sceneGroup:insert( background )

	backButton = display.newImageRect( "img/back.png", 100, 50 )
	backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
	backButton.x = backButton.width/2 + 20
	backButton.y = backButton.height/2 + 20

	backButtonGroup = display.newGroup()
	backButtonGroup:insert( backButton )
	sceneGroup:insert( backButtonGroup )

	playButtonGroup = display.newGroup()
	print(session.getCustomLevelCount())
	if(session.getCustomLevelCount() > 0) then
		playButton = display.newImageRect( "img/playCustom.png", 100, 50 )
		playButton:setFillColor( unpack( settings.getButtonOffColor() ) )
		playButton.x = display.contentCenterX
		playButton.y = display.contentHeight/3 + 100

		-- if leaderSpot <= 50 then
		-- 	createButton.alpha = 0
		-- end

		playButtonGroup:insert( playButton )
		sceneGroup:insert( playButtonGroup )
	end

		local leaderSpot = session.getLeaderboardPlace()
		local leaderTextOptions =
		{
			text = strings.customGameLeaderBoard1 .. leaderSpot .. strings.customGameLeaderBoard2,
			x = display.contentCenterX,
			y = display.contentHeight/3,
			width = display.contentWidth - 50,
			fontSize = 20,
			align = "center"
		}
		local leaderText = display.newText( leaderTextOptions )
		leaderText:setFillColor( 0, 0, 0 )
		sceneGroup:insert( leaderText )

		createButton = display.newImageRect( "img/create.png", 100, 50 )
		createButton:setFillColor( unpack( settings.getButtonOffColor() ) )
		createButton.x = display.contentCenterX
		createButton.y = display.contentHeight*3/4

		createButtonGroup = display.newGroup()
		createButtonGroup:insert( createButton )
		sceneGroup:insert( createButtonGroup )
end

--- Called twice, once BEFORE, and once immediately after scene has moved onscreen.
-- @tparam event event Event fired by the composer API.
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	---------------------------------------
	-- BEFORE the scene has moved onscreen.
	---------------------------------------
	if ( phase == "will" ) then
	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then

		function backPressed( event )
			local phase = event.phase

			if phase == "began" then
				backButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.gotoScene("view.titleScene")
			end
		end

		function createPressed( event )
			local phase = event.phase

			if phase == "began" then
				backButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.gotoScene("view.createGameScene")
			end
		end

		if(session.getCustomLevelCount() > 0) then
			function playPressed( event )
				local phase = event.phase

				if phase == "began" then
					backButton:setFillColor( unpack( settings.getButtonOnColor() ) )
				elseif phase == "ended" then
					backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
					composer.gotoScene("view.playCustomScene")
				end
			end
			playButtonGroup:addEventListener( "touch", playPressed )
		end

		backButtonGroup:addEventListener( "touch", backPressed )
		createButtonGroup:addEventListener( "touch", createPressed )

	end
end

--- Called twice, once when the screen is about to, and once when it has finished moving offscreen.
-- @tparam event event Event fired by the composer API.
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	----------------------------------------------
	-- When the screen is about to move offscreen.
	----------------------------------------------
	if ( phase == "will" ) then
		backButtonGroup:removeEventListener( "touch", backPressed )
		createButtonGroup:removeEventListener( "touch", createPressed )
		if(session.getCustomLevelCount() > 0) then
			playButtonGroup:removeEventListener( "touch", playPressed )
		end
	------------------------------------------------
	-- When the scene has finished moving offscreen.
	------------------------------------------------
	elseif ( phase == "did" ) then
	end
end

--- Called prior to removal of scene's view (can be recycled or removed).
-- @tparam event event Event fired by the composer API.
function scene:destroy( event )
	local sceneGroup = self.view
	-----------------------------------------------------------------------------
	-- Called prior to the removal of scene's view ("sceneGroup").
	-- Insert code here to clean up the scene.
	-- Example: remove display objects, save state, etc.
	-----------------------------------------------------------------------------
end

--- Custom functions.
-- Custom functions that provide additional functionality and are called from this Scene or its associated controller.
-- @section custom

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
