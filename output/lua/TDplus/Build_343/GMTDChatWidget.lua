
Script.Load("lua/TDplus/Build_343/PlusEmoteButton.lua")

emotemenufull = PrecacheAsset("ui/emotemenufull.dds")
local noEmote = PrecacheAsset("ui/emptyonebyone.dds")

oldGMTDChatWidgetAddNewChatMessage = GMTDChatWidget.AddNewChatMessage
function GMTDChatWidget:AddNewChatMessage(lobbyId, senderName, senderTeam, message, senderSteamID64)

    local k = string.find(message, "/watch" )
    if k == 1 then
      -- send the link to menu navbar
      youtubePopup("https://www.youtube.com" .. message)
    end

  oldGMTDChatWidgetAddNewChatMessage(self, lobbyId, senderName, senderTeam, message, senderSteamID64)

    local chatIndex = #self.chatMessages
    self:HookEvent(self.emotemenu, "hideEmotes", function()
      self.chatMessages[chatIndex].emoteIcon:SetVisible(false)
    end)
    self:HookEvent(self.emotemenu, "showEmotes", function()
        self.chatMessages[chatIndex].emoteIcon:SetVisible(true)
    end)

    self.chatMessages[chatIndex].emoteIcon:SetVisible(not self.emotemenu.iconRed:GetVisible())
end

oldGMTDChatWidgetClear = GMTDChatWidget.Clear
function GMTDChatWidget:Clear()
    self:UnHookEventsByName("hideEmotes")
    self:UnHookEventsByName("showEmotes")
    oldGMTDChatWidgetClear(self)
end



oldGMTDChatWidgetInitialize = GMTDChatWidget.Initialize
function GMTDChatWidget:Initialize(params, errorDepth)

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