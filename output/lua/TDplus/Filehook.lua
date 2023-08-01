


if Client then

	--adds some console commands
	Script.Load("lua/TDplus/PlusConsoleCommands.lua")

	-- translates spaces from own and other messages to emojis
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDChatWidgetMessage.lua", "lua/TDplus/GMTDChatWidgetMessage.lua", "post")

	-- translates emojis to spaces
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDChatWidget.lua", "lua/TDplus/GMTDChatWidget.lua", "post")

	-- Sorts Mapvotes
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GMTDMapVoteScreen.lua", "lua/TDplus/GMTDMapVoteScreen.lua", "post")

	-- added hiveskills and ns2panel to contextmenu. Reduces buttonsizes
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDPlayerPlaqueContextMenu.lua", "lua/TDplus/GMTDPlayerPlaqueContextMenu.lua", "post")

	-- added babbler minigame and lobbyID in Name
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GMTDLobbyScreen.lua", "lua/TDplus/GMTDLobbyScreen.lua", "post")

	-- added hiveskill number under the name
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GMTDPlayerPlaqueWidget.lua", "lua/TDplus/GMTDPlayerPlaqueWidget.lua", "post")

	--youtube player
	ModLoader.SetupFileHook( "lua/menu2/NavBar/GUIMenuNavBar.lua", "lua/TDplus/GUIMenuNavBar.lua", "post")

	-- local kInactivityDelay = 1000
	ModLoader.SetupFileHook( "lua/GUI/GUIWebPageView.lua", "lua/TDplus/GUIWebPageView.lua", "replace")

	-- adds the calls for the hiveskill bar and playtime progress
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GUIMenuThunderdome.lua", "lua/TDplus/GUIMenuThunderdome.lua", "post")

	--add mapvote results to the planning window
	ModLoader.SetupFileHook( "lua/menu2/NavBar/Screens/Thunderdome/GMTDPlanningScreen.lua", "lua/TDplus/GMTDPlanningScreen.lua", "post")

	-- replace to access local delay 
	ModLoader.SetupFileHook( "lua/menu2/widgets/Thunderdome/GUIMenuLobbyFriendEntry.lua", "lua/TDplus/GUIMenuLobbyFriendEntry.lua", "replace")
	



	Log("████████╗██████╗     ██████╗ ██╗     ██╗   ██╗███████╗")
	Log("╚══██╔══╝██╔══██╗    ██╔══██╗██║     ██║   ██║██╔════╝")
	Log("   ██║   ██║  ██║    ██████╔╝██║     ██║   ██║███████╗")
	Log("   ██║   ██║  ██║    ██╔═══╝ ██║     ██║   ██║╚════██║")
	Log("   ██║   ██████╔╝    ██║     ███████╗╚██████╔╝███████║")
	Log("   ╚═╝   ╚═════╝     ╚═╝     ╚══════╝ ╚═════╝ ╚══════╝")											  
end
