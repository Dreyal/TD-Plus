-- hourdata will get removed at mapvote to prepare for planning stage
-- leaver at the mapvote stage force us to re-apply it
local HoursInLifefromData = false 





local oldGUIMenuThunderdomeInitialize = GUIMenuThunderdome.Initialize
function GUIMenuThunderdome:Initialize(params, errorDepth)

    oldGUIMenuThunderdomeInitialize(self, params, errorDepth)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILeaveLobby,              self.TD_OnLobbyLeft)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUIMapVoteStart,    self.TDMapVoteStarted)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyMemberJoin,           self.TD_UpdateStatusBars)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyMemberLeave,          self.TD_UpdateStatusBars)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyMemberKicked,         self.TD_UpdateStatusBars)
    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUILobbyJoined,                  self.TDLobbyJoined)

    Thunderdome_RemoveListener(kThunderdomeEvents.OnGUIMaxLobbyLifespanNotice,  self.TD_MaxLobbyLifespanPrompt)

    local oldTDMapVoteStarted = self.TDMapVoteStarted
    self.TDMapVoteStarted = function( clientObject, lobbyId )
        oldTDMapVoteStarted(clientObject, lobbyId)



        showBars()
        deleteHoursInLifeforms()
        self:RemoveTimedCallback(self.hoursCallback)
        self.hoursCallback = nil


        self:RemoveTimedCallback(self.apathyCallback)
        self.apathyCallback = nil

    end

    local oldTD_UpdateStatusBars = self.TD_UpdateStatusBars
    self.TD_UpdateStatusBars = function( clientObject, memberId, lobbyId )
        oldTD_UpdateStatusBars(clientObject, memberId, lobbyId)

        hideBars() -- why?
        if not self.hoursCallback and not HoursInLifefromData and not Thunderdome():GetIsGroupId(lobbyId) then 
            self.hoursCallback = self:AddTimedCallback( self.writeHoursInLifeforms, 2)
        end
        
        if not self.apathyCallback and not Thunderdome():GetIsGroupId(lobbyId) then 
            self.cachedLobbyID = lobbyId
            self.apathyCallback = self:AddTimedCallback( self.updateApathy, 2)
        end
    end

    local oldTDLobbyJoined = self.TDLobbyJoined
    self.TDLobbyJoined = function( clientObject, lobbyId )
        oldTDLobbyJoined(clientObject, lobbyId)

        HoursInLifefromData = false
        if not self.hoursCallback and not Thunderdome():GetIsGroupId(lobbyId) then 
            self.hoursCallback = self:AddTimedCallback( self.writeHoursInLifeforms, 2)
        end
        hideBars()
        self:RemoveTimedCallback(self.searchAfterAfkCallback)
        self.searchAfterAfkCallback = nil

        if not self.apathyCallback and not Thunderdome():GetIsGroupId(lobbyId) then 
            self.cachedLobbyID = lobbyId
            self.apathyCallback = self:AddTimedCallback( self.updateApathy, 2)
        end
    end

    --TODO causes some issues if the client searches manually at the same time
    local oldTD_MaxLobbyLifespanPrompt = self.TD_MaxLobbyLifespanPrompt
    self.TD_MaxLobbyLifespanPrompt = function(clientModeObject)
        oldTD_MaxLobbyLifespanPrompt(clientModeObject)

        -- delayed callback for starting a lobbysearch
        if not self.searchAfterAfkCallback and TDseedingMode then 
            ran = math.random(10,20)
            Shared.Message(string.format("auto searches in %d seconds", ran))
            self.searchAfterAfkCallback = self:AddTimedCallback(self.ShowSearchScreen, ran)
        end
    end

    
    


    
    local oldTD_OnLobbyLeft = self.TD_OnLobbyLeft
    self.TD_OnLobbyLeft = function( clientObject, lobbyId ) -- params are nil
        oldTD_OnLobbyLeft(clientObject, lobbyId)
        disableYoutube()


        self:RemoveTimedCallback(self.hoursCallback)
        self.hoursCallback = nil
        HoursInLifefromData = false

        self:RemoveTimedCallback(self.apathyCallback)
        self.apathyCallback = nil
        
    end

    Thunderdome_AddListener(kThunderdomeEvents.OnGUIMaxLobbyLifespanNotice,  self.TD_MaxLobbyLifespanPrompt)

    Thunderdome_AddListener(kThunderdomeEvents.OnGUILeaveLobby,      self.TD_OnLobbyLeft)
    Thunderdome_AddListener(kThunderdomeEvents.OnGUIMapVoteStart,  self.TDMapVoteStarted)

    Thunderdome_AddListener(kThunderdomeEvents.OnGUILobbyJoined,                  self.TDLobbyJoined)
    Thunderdome_AddListener(kThunderdomeEvents.OnGUILobbyMemberLeave,          self.TD_UpdateStatusBars)
    Thunderdome_AddListener(kThunderdomeEvents.OnGUILobbyMemberKicked,         self.TD_UpdateStatusBars)
    Thunderdome_AddListener(kThunderdomeEvents.OnGUILobbyMemberJoin,           self.TD_UpdateStatusBars)
  end




-- yes this is hacky. We dont have many ways to share data with other modded clients
function GUIMenuThunderdome:writeHoursInLifeforms()
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

    HoursInLifefromData = true

    Thunderdome():SetLocalLifeformsChoices(lifeformChoices)
end


-- called when the mapvote starts
function deleteHoursInLifeforms()
    local lifeformChoices = {}
    Thunderdome():SetLocalLifeformsChoices(lifeformChoices)
    HoursInLifefromData = false
end


--when global variable TDseedingMode is true, abort lobby at 10/11 player
local oldGUIMenuThunderdomeUpdateStatusBars = GUIMenuThunderdome.UpdateStatusBars
function GUIMenuThunderdome:UpdateStatusBars( lobbyId )
    oldGUIMenuThunderdomeUpdateStatusBars(self, lobbyId)

    if TDseedingMode then 
        local members = Thunderdome():GetMemberListLocalData( lobbyId )
        if not members then return end
        if #members == 2 or #members == 11 then  -- TODO change to 10 again
            local td = Thunderdome()


            --leaving the lobby like this causes an error at displaying the statusbar at ThunderdomeExports.lua:198 (lobby = nil)
            td:LeaveLobby(td:GetActiveLobbyId(), true)


            Shared.Message("Left lobby at 10 players due to seeding mode enabled.")
            TDseedingMode = false
            Shared.Message("Autoleave at 10 Player: " .. tostring(TDseedingMode))
        end
    end
end


-- called everytime someone leaves or joins except when youre leaving yourself
function GUIMenuThunderdome:updateApathy()
    
    local requestUrl = "https://lobby.fortreeforums.xyz/thunderdome/add.php?id=" .. tostring(self.cachedLobbyID)
    local generatedUrl = ""
    local playerId     = "&player[]="
    local name       = "&name[]="
    local isCommander = "&isCommander[]="
    local join_time = "&join_time[]="

    local memberData = Thunderdome():GetMemberListLocalData(self.cachedLobbyID)
    if not memberData then 
        return 
    end 

    for i = 1, #memberData do 
        local ply = memberData[i]
        ply.steamid = Shared.ConvertSteamId64To32(ply.steamid)
        generatedUrl = string.format("%s%s%s%s%s%s%s%s%s", generatedUrl, playerId, ply.steamid , name, ply.name, isCommander, ply.commander_able, join_time, ply.join_time)
    end

    local completeUrl = requestUrl .. generatedUrl
    Shared.Message("Sending lobbyinfo to " .. requestUrl)
    Shared.SendHTTPRequest(completeUrl, "GET")   
    
end

