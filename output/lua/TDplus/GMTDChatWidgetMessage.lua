


Script.Load("lua/GUI/layouts/GUIListLayout.lua")

Script.Load("lua/TDplus/PlusGif.lua")
Script.Load("lua/menu2/widgets/Thunderdome/GMTDLoadingGraphic.lua")

local kMessageTextFontFamily = "Arial"
local kMessageTextFontSize = 22


local kMessageClipHeight = -1
local kMessageMaxClipWidth = 9999 -- Theres no negative for width, sooo
local commanderIconPadding = 10

local kPadding = 15


local oldGMTDChatWidgetMessageInitialize = GMTDChatWidgetMessage.Initialize

function GMTDChatWidgetMessage:Initialize(params, errorDepth)
      oldGMTDChatWidgetMessageInitialize(self, params, errorDepth)
      self.emoteIcon = CreateGUIObject("emoteIcon", PlusGif, self)
      self.emoteIcon:SetVisible(false)
end


--[[
    emote position is still not quite right. It goes over text a line below if its by the same sender
]]
function GMTDChatWidgetMessage:ApplyEmotesForSpacecounters(message, isExtension, senderWidth, senderHeight, object,commanderPadding)

          local index = -1
          local spaceCounter = 0
          while string.byte(message, index) == 32 do
              spaceCounter = spaceCounter + 1
              index = index -1
          end
          self.bigemote = false

          -- we got 30 pictures at 2 to 31 and also a babbler for the game at 32
          if spaceCounter > 1 and spaceCounter < 33 then

            self.spaces = spaceCounter


            message = message:gsub("%s+", " ")

            self.preText = CreateGUIObject("preText", GUIText, self)
            self.preText:SetFont(kMessageTextFontFamily, kMessageTextFontSize)
            self.preText:SetText(message)
            self.preText:SetVisible(false)

            local textLength = self.preText:GetSize().x

            local transOffset = 0


            if self.spaces == 4 then -- veil 
                object:SetTexture("ui/veildance.dds")
                object:SetFloatParameter("framesPerSecond",  40 )
                object:SetFloatParameter("horizontalFrames", 5)
                object:SetFloatParameter("verticalFrames",   5  )
                object:SetFloatParameter("numFrames",        25   )
            elseif self.spaces == 5 then -- blob 
                object:SetTexture("ui/blobdance2.dds")
                object:SetFloatParameter("framesPerSecond",  48 )
                object:SetFloatParameter("horizontalFrames", 5)
                object:SetFloatParameter("verticalFrames",   8  )
                object:SetFloatParameter("numFrames",        37   )
                transOffset = 1
            elseif self.spaces == 6 then -- rat 
                object:SetTexture("ui/ratdance2.dds")
                object:SetFloatParameter("framesPerSecond",  35 )
                object:SetFloatParameter("horizontalFrames", 5)
                object:SetFloatParameter("verticalFrames",   7  )
                object:SetFloatParameter("numFrames",        35   )
                transOffset = 1
            elseif self.spaces == 30 then -- cat
                object:SetTexture("ui/bongocat.dds")
                object:SetFloatParameter("framesPerSecond",  14 )
                object:SetFloatParameter("horizontalFrames", 5)
                object:SetFloatParameter("verticalFrames",   1  )
                object:SetFloatParameter("numFrames",        2   )
            elseif self.spaces == 32 then -- babbler for game
                object:SetTexture("ui/TDbabblerSmall.dds")
                object:SetFloatParameter("framesPerSecond",  1 )
                object:SetFloatParameter("horizontalFrames", 1)
                object:SetFloatParameter("verticalFrames",   1  )
                object:SetFloatParameter("numFrames",        1   )
            else
                local emotemenuiconDetails = GetEmoteTextureDetails(self.spaces -2 ) -- expects value between 0-29
                object:SetTexture(emotemenufull)
                object:SetTexturePixelCoordinates(emotemenuiconDetails.texCoords)
            end


            object:SetColor(1,1,1)
            local TopPadding = 4
            if not isExtension then
                textLength = textLength + senderWidth
                TopPadding = kPadding + 10
            end

            textLength = textLength

            if textLength > 1670 then
                textLength = 1670
            end

            if message == " " then
                senderHeight = 96
                self.bigemote = true
                transOffset = transOffset * 2
            end
            self.commpad = self.commpad or 0
            self.commpad = self.commpad + commanderPadding

            object:SetSize(transOffset * 2 + senderHeight, transOffset * 2 + senderHeight)
            object:SetPosition(textLength - transOffset + commanderPadding*5, TopPadding - transOffset)
            object:SetLayer(1000)
            end
      return message
end




--[[
    Changing the senderheight could be the cause of the subpixel issues with emotes and comm badges
]]
function GMTDChatWidgetMessage:UpdateTextFormatting()
    local isExtension = self:GetIsExtension()
    local fullMessage = self:GetSenderMessage()

    local isCommander = self:GetIsCommander() and not isExtension -- Only show commander icon next to sender name
    if fullMessage == "" or ( self:GetSenderName() == "" and self:GetSenderSteamID64() ~= kThunderdomeSystemUserId) then
        return
    end

    local topPadding
    local senderWidth
    local senderHeight
    local commanderPadding

    if isExtension then
        topPadding = 0
        senderWidth  = 0
        senderHeight = 0
        commanderPadding = 0

    else
        topPadding = kPadding
        senderWidth  = self.senderText:GetSize().x
        senderHeight = self.senderText:GetSize().y
        commanderPadding = isCommander and commanderIconPadding or 0

    end


    -- Update visibility and split full message into fitting parts.
    local maxWidth = self:GetMaxWidth()
    self.senderText:SetVisible(not isExtension)

    local commanderIconSizeScalar = 0
    if isCommander then
        commanderIconSizeScalar = senderHeight
        self.commanderIcon:SetSize(commanderIconSizeScalar, commanderIconSizeScalar)
        self.commanderIcon:SetPosition(0, topPadding)
    end



    --deletes spaces and replaces them with an emote
    fullMessage = self:ApplyEmotesForSpacecounters(fullMessage, isExtension, senderWidth, self.senderText:GetSize().y, self.emoteIcon,commanderPadding)
    --
    if self.bigemote then
     senderHeight = 96
   end


    self.senderText:SetPosition(commanderIconSizeScalar + commanderPadding, topPadding)

    local messageTop, messageBottom = TextWrap(self.senderMessageText:GetTextObject(), fullMessage, 0, maxWidth - senderWidth - commanderIconSizeScalar - commanderPadding)
    messageTop = messageTop or ""

    messageBottom = messageBottom or ""




    self.senderMessageText:SetText(messageTop)
    self.senderMessageText2:SetText(messageBottom)

    -- Set position of the top message
    local topMessageHeight = self.senderMessageText:GetSize().y
    local topMessagePositionX = senderWidth + commanderIconSizeScalar + commanderPadding
    local topMessagePositionY = ConditionalValue(isExtension, 0, topPadding + (senderHeight - topMessageHeight))
    self.senderMessageText:SetPosition(topMessagePositionX, topMessagePositionY)

    -- Update bottom message position and paragraph size
    local widthForBottomMessage = maxWidth
    local bottomMessageTopPadding = 0
    local bottomMessageClipWidth = ConditionalValue(maxWidth < 0, kMessageMaxClipWidth, widthForBottomMessage)
    self.senderMessageText2:SetParagraphSize(bottomMessageClipWidth, kMessageClipHeight)
    self.senderMessageText2:SetPosition(0, topMessagePositionY + topMessageHeight + bottomMessageTopPadding)

    local bottomMessageHeight = ConditionalValue(messageBottom == "", 0, self.senderMessageText2:GetSize().y)

    local totalHeight = math.max(topPadding + senderHeight, topMessagePositionY + topMessageHeight) + bottomMessageTopPadding + bottomMessageHeight

    self:SetSize(maxWidth, totalHeight)

    self.senderMessageText:SetVisible(true)
    self.senderMessageText2:SetVisible(bottomMessageHeight > 0)
    self.commanderIcon:SetVisible(isCommander)

end
