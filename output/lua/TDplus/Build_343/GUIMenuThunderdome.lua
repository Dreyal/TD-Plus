
oldGUIMenuThunderdomeInitialize = GUIMenuThunderdome.Initialize
function GUIMenuThunderdome:Initialize(params, errorDepth)

    oldGUIMenuThunderdomeInitialize(self, params, errorDepth)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILeaveLobby,              self.TD_OnLobbyLeft)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUIMapVoteStart,    self.TDMapVoteStarted)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyMemberLeave,          self.TD_UpdateStatusBars)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyMemberKicked,         self.TD_UpdateStatusBars)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyJoined,                  self.TDLobbyJoined)


    oldTDMapVoteStarted = self.TDMapVoteStarted
    self.TDMapVoteStarted = function( clientObject, lobbyId )
        oldTDMapVoteStarted(self, clientObject, lobbyId)
        showBars()
    end

    oldTD_UpdateStatusBars = self.TD_UpdateStatusBars
    self.TD_UpdateStatusBars = function( clientObject, memberId, lobbyId )
        oldTD_UpdateStatusBars(self, clientObject, memberId, lobbyId)
        hideBars()
    end

    oldTDLobbyJoined = self.TDLobbyJoined
    self.TDLobbyJoined = function( clientObject, lobbyId )
        oldTDLobbyJoined(self, clientObject, lobbyId)
        hideBars()
    end

    
    oldTD_OnLobbyLeft = self.TD_OnLobbyLeft
    self.TD_OnLobbyLeft = function( clientObject, lobbyId )
        oldTD_OnLobbyLeft(self, clientObject, lobbyId)
        disableYoutube()
    end

    Thunderdome_AddListener(kThunderdomeEvents.OnGUILeaveLobby,      self.TD_OnLobbyLeft)
    Thunderdome_AddListener(kThunderdomeEvents.OnGUIMapVoteStart,  self.TDMapVoteStarted)

    Thunderdome_AddListener(kThunderdomeEvents.OnGUILobbyJoined,                  self.TDLobbyJoined)
    Thunderdome_AddListener(kThunderdomeEvents.OnGUILobbyMemberLeave,          self.TD_UpdateStatusBars)
    Thunderdome_AddListener(kThunderdomeEvents.OnGUILobbyMemberKicked,         self.TD_UpdateStatusBars)
  end
