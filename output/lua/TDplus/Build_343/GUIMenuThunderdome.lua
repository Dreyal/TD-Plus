
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
        deleteHoursInLifeforms()
    end

    oldTD_UpdateStatusBars = self.TD_UpdateStatusBars
    self.TD_UpdateStatusBars = function( clientObject, memberId, lobbyId )
        oldTD_UpdateStatusBars(self, clientObject, memberId, lobbyId)
        hideBars()
    end

    oldTDLobbyJoined = self.TDLobbyJoined
    self.TDLobbyJoined = function( clientObject, lobbyId )
        oldTDLobbyJoined(self, clientObject, lobbyId)
        writeHoursInLifeforms()
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

-- yes this is hacky. We dont have many ways to share data with other modded clients
function writeHoursInLifeforms()
    local fieldhours = Client.GetUserStat_Int("td_total_time_player") or 0
    fieldhours = math.floor(fieldhours / 3600)
   

    -- to differentiate between sub 1h and no modded clients we save the 0 as 2500 hours
    if fieldhours == 0 then 
        table.insert(lifeformChoices, "Onos")
        table.insert(lifeformChoices, "Onos")
        table.insert(lifeformChoices, "Onos")
        table.insert(lifeformChoices, "Onos")
    end

    local lifeformChoices = {}
    local k = fieldhours % 5
    for i = 1, k, 1 do 
        table.insert(lifeformChoices, "Skulk")
    end
    fieldhours = fieldhours - k
    k = fieldhours % 25
    for i = 5, k, 5 do 
        table.insert(lifeformChoices, "Gorge")
    end
    fieldhours = fieldhours - k
    k = fieldhours % 125
    for i = 25, k, 25 do 
        table.insert(lifeformChoices, "Lerk")
    end
    fieldhours = fieldhours - k
    k = fieldhours % 625
    for i = 125, k, 125 do 
        table.insert(lifeformChoices, "Fade")
    end
    fieldhours = fieldhours - k
    k = fieldhours % 3125
    for i = 625, k, 625 do 
        table.insert(lifeformChoices, "Onos")
    end

    Thunderdome():SetLocalLifeformsChoices(lifeformChoices)
end

function deleteHoursInLifeforms()
    local lifeformChoices = {}
    Thunderdome():SetLocalLifeformsChoices(lifeformChoices)
end