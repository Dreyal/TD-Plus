
Script.Load("lua/TDplus/PlusEmoteButton.lua")

emotemenufull = PrecacheAsset("ui/emotemenufull.dds")
local noEmote = PrecacheAsset("ui/emptyonebyone.dds")

local oldGMTDChatWidgetAddNewChatMessage = GMTDChatWidget.AddNewChatMessage
function GMTDChatWidget:AddNewChatMessage(lobbyId, senderName, senderTeam, message, senderSteamID64)

    local newMessageMuted = false 

    for i = 1, #self.mutedSteamIds do
        if self.mutedSteamIds[i] == senderSteamID64 then   
            newMessageMuted = true
        end
    end


    local k = string.find(message, "/watch" )
    if k == 1 and newMessageMuted == false then
      -- send the link to menu navbar
      youtubePopup("https://www.youtube.com" .. message)
    end

    local j = string.find(message, "youtu.be/")
    if j == 1 and newMessageMuted == false then  
        youtubePopup(message)
    end

    oldGMTDChatWidgetAddNewChatMessage(self, lobbyId, senderName, senderTeam, message, senderSteamID64)
    
    local chatIndex = #self.chatMessages
    self:HookEvent(self.emotemenu, "hideEmotes", function()
      self.chatMessages[chatIndex].emoteIcon:SetVisible(false)
    end)
    self:HookEvent(self.emotemenu, "showEmotes", function()
        self.chatMessages[chatIndex].emoteIcon:SetVisible(true)
    end)


    local function OnMute(self, steamId)
        if self.chatMessages[chatIndex]:GetSenderSteamID64() == steamId then
            self.chatMessages[chatIndex].emoteIcon:SetVisible(false)
            self.chatMessages[chatIndex]:SetVisible(false)
        end
    end
    self:HookEvent(self, "mute", OnMute)

    local function OnUnmute(self, steamId)
        if self.chatMessages[chatIndex]:GetSenderSteamID64() == steamId then
            self.chatMessages[chatIndex].emoteIcon:SetVisible(not self.emotemenu.iconRed:GetVisible())
            self.chatMessages[chatIndex]:SetVisible(true)
        end
    end
    self:HookEvent(self, "unmute", OnUnmute)


    self.chatMessages[chatIndex].emoteIcon:SetVisible(not self.emotemenu.iconRed:GetVisible() and not newMessageMuted)
    self.chatMessages[chatIndex]:SetVisible(not newMessageMuted)
end

local oldGMTDChatWidgetClear = GMTDChatWidget.Clear
function GMTDChatWidget:Clear()
    self:UnHookEventsByName("hideEmotes")
    self:UnHookEventsByName("showEmotes")
    self:UnHookEventsByName("mute")
    self:UnHookEventsByName("unmute")
    oldGMTDChatWidgetClear(self)
end


--TODO add copy paste
local oldGMTDChatWidgetInitialize = GMTDChatWidget.Initialize
function GMTDChatWidget:Initialize(params, errorDepth)



        --array of steam64Id strings which denote local-client won't see chat messages from
        self.mutedSteamIds = {}
       
    
      --emote would overlap with the message
        if params.label == "TEAM CHAT" then
            params.label = "CHAT"
        end

      oldGMTDChatWidgetInitialize(self,params,errorDepth)

      self.spaceAmount = 1
      self.emotemenu = CreateGUIObject("emoteMenuButton", PlusEmoteButton, self,
          {
          },
          errorDepth)
      self.emotemenu:AlignBottomRight()
      self.emotemenu:SetLayer(2001)

      self:HookEvent(self.emotemenu, "setChatFocused", function() self:SetChatWidgetFocused() end)


      self.editLineEmote = CreateGUIObject("emoteIcon", GUIButton, self.chatInput)
      self.editLineEmote:SetTexture(noEmote)
      self.editLineEmote:SetColor(1,1,1)
      self.editLineEmote:SetSize(60, 60)
      self.editLineEmote:SetPosition(130,10)
      self.editLineEmote:SetVisible(true)
      self.editLineEmote:SetLayer(1000)


      for j = 2, 31 do
          self:HookEvent(self.emotemenu, tostring(j), function()
              self:SetChatWidgetFocused()
              if self.spaceAmount == j then -- reset the emote
                self.spaceAmount = 1
                self.editLineEmote:SetTexture(noEmote)
              else
                self.spaceAmount = j
                local emotemenuiconDetails = GetEmoteTextureDetails(j -2 )
                self.editLineEmote:SetTexture(emotemenufull)
                self.editLineEmote:SetTexturePixelCoordinates(emotemenuiconDetails.texCoords)
              end
          end)
      end

      self:HookEvent(self.chatInput, "OnValueChanged", function()
          self.editLineEmote:SetPosition(self.chatInput.entry:GetSize().x + 130 , 10)
      end)
end

function GMTDChatWidget:GetMutedClients()
    return self.mutedSteamIds
end

--fire a check for all messages by the ID to be hidden
function GMTDChatWidget:AddMutedClient(steamId)
    assert(steamId)
    self:FireEvent("mute", steamId)
    table.insert(self.mutedSteamIds, steamId)
 end


 --fire a check for all messages by the ID to be visible again
 function GMTDChatWidget:RemoveMutedClient( steamId )
     assert(steamId)
     self:FireEvent("unmute", steamId)
     for i = 1, #self.mutedSteamIds do
        if self.mutedSteamIds[i] == steamId then
            table.remove( self.mutedSteamIds, i )
        end
    end
 end


function GMTDChatWidget:OnChatInputAccepted()
    local td = Thunderdome()
    assert(td, "Error: No valid Thunderdome object found!")

    local lobbyId = nil
    if td:GetIsGroupQueueEnabled() then
        lobbyId = td:GetGroupLobbyId()
    else
        lobbyId = td:GetActiveLobbyId()
    end
    assert(lobbyId, "Error: No valid LobbyModel found for any lobby-type")

    local lastSendTime = self:GetLastChatSendTime()
    local now = Shared.GetSystemTime()

    if (lastSendTime + kLobbyChatSendRate) < now then
        local message = self.chatInput:GetValue()

        -- add spaces at the end of a message to share the emote
        message = message .. " "
        message = message:gsub("%s+", " ") -- Trim all space characters to be just 1 space.

        for i = 2, self.spaceAmount do
            message = message .. " "
        end

        self.spaceAmount = 1
        self.editLineEmote:SetTexture(noEmote)

        td:SendChatMessage( message, lobbyId )
        self.chatInput:SetValue("")
        self:SetLastChatSendTime(now)

    end
    self.chatInput:SetEditing(true) -- never leave focus of text entry when sending a message.
end

function GMTDChatWidget:SetChatWidgetFocused()
    self.chatInput:SetEditing(true)
end


