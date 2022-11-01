


if Client then

	--adds some console commands
	Script.Load("lua/TDplus/Build_343/PlusConsoleCommands.lua")

	-- translates spaces from own and other messages to emojis
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDChatWidgetMessage.lua", "lua/TDplus/Build_343/GMTDChatWidgetMessage.lua", "post")

	-- translates emojis to spaces
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDChatWidget.lua", "lua/TDplus/Build_343/GMTDChatWidget.lua", "post")

	-- Sorts Mapvotes
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GMTDMapVoteScreen.lua", "lua/TDplus/Build_343/GMTDMapVoteScreen.lua", "post")

	-- added hiveskills and ns2panel to contextmenu. Reduces buttonsizes
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDPlayerPlaqueContextMenu.lua", "lua/TDplus/Build_343/GMTDPlayerPlaqueContextMenu.lua", "post")

	-- added babbler minigame and lobbyID in Name
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GMTDLobbyScreen.lua", "lua/TDplus/Build_343/GMTDLobbyScreen.lua", "post")

	-- added hiveskill number under the name
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDPlayerPlaqueWidget.lua", "lua/TDplus/Build_343/GMTDPlayerPlaqueWidget.lua", "post")

	--youtube player
	ModLoader.SetupFileHook( "lua/menu2/NavBar/GUIMenuNavBar.lua", "lua/TDplus/Build_343/GUIMenuNavBar.lua", "post")

	-- local kInactivityDelay = 1000
	ModLoader.SetupFileHook( "lua/GUI/GUIWebPageView.lua", "lua/TDplus/Build_343/GUIWebPageView.lua", "replace")

	-- adds the calls for the hiveskill bar
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GUIMenuThunderdome.lua", "lua/TDplus/Build_343/GUIMenuThunderdome.lua", "post")

	--add mapvote results to the planning window
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GMTDPlanningScreen.lua", "lua/TDplus/Build_343/GMTDPlanningScreen.lua", "post")
end
