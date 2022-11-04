
local oldGUIMenuThunderdomeInitialize = GUIMenuThunderdome.Initialize
function GUIMenuThunderdome:Initialize(params, errorDepth)

    oldGUIMenuThunderdomeInitialize(self, params, errorDepth)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILeaveLobby,              self.TD_OnLobbyLeft)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUIMapVoteStart,    self.TDMapVoteStarted)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyMemberLeave,          self.TD_UpdateStatusBars)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyMemberKicked,         self.TD_UpdateStatusBars)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyJoined,                  self.TDLobbyJoined)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUIMaxLobbyLifespanNotice,  self.TD_MaxLobbyLifespanPrompt)

    local oldTDMapVoteStarted = self.TDMapVoteStarted
    self.TDMapVoteStarted = function( clientObject, lobbyId )
        oldTDMapVoteStarted(self, clientObject, lobbyId)
        showBars()
        deleteHoursInLifeforms()
    end

    local oldTD_UpdateStatusBars = self.TD_UpdateStatusBars
    self.TD_UpdateStatusBars = function( clientObject, memberId, lobbyId )
        oldTD_UpdateStatusBars(self, clientObject, memberId, lobbyId)
        hideBars()
    end

    local oldTDLobbyJoined = self.TDLobbyJoined
    self.TDLobbyJoined = function( clientObject, lobbyId )
        oldTDLobbyJoined(self, clientObject, lobbyId)
        writeHoursInLifeforms()
        hideBars()
        self:RemoveTimedCallback(searchAfterAfkCallback)
        self.searchAfterAfkCallback = nil
    end

    local oldTD_MaxLobbyLifespanPrompt = self.TD_MaxLobbyLifespanPrompt
    self.TD_MaxLobbyLifespanPrompt = function(clientModeObject)
        oldTD_MaxLobbyLifespanPrompt(self, clientModeObject)
        -- delayed callback for starting a lobbysearch
        if not self.searchAfterAfkCallback and SearchAfterAfkLobby then 
            ran = math.random(10,20)
            Shared.Message(string.format("auto searches in %d seconds", ran))
            self.searchAfterAfkCallback = self:AddTimedCallback(self.ShowSearchScreen, ran)
        end
    end

    
    local oldTD_OnLobbyLeft = self.TD_OnLobbyLeft
    self.TD_OnLobbyLeft = function( clientObject, lobbyId )
        oldTD_OnLobbyLeft(self, clientObject, lobbyId)
        disableYoutube()
    end

    Thunderdome_AddListener(kThunderdomeEvents.OnGUIMaxLobbyLifespanNotice,  self.TD_MaxLobbyLifespanPrompt)

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

local oldGUIMenuThunderdomeUpdateStatusBars = GUIMenuThunderdome.UpdateStatusBars
function GUIMenuThunderdome:UpdateStatusBars( lobbyId )
    oldGUIMenuThunderdomeUpdateStatusBars(self, lobbyId)

    if LeaveBeforeTen then 
        local members = Thunderdome():GetMemberListLocalData( lobbyId )
        if not members then return end
        if #members > 0 then 
            local td = Thunderdome()
            td:LeaveLobby(td:GetActiveLobbyId(), true)
            Shared.Message("Left lobby due to autoleave at 10 players")
            LeaveBeforeTen = false
            Shared.Message("Autoleave at 10 Player: " .. tostring(LeaveBeforeTen))
        end
    end
    
end