

Script.Load("lua/GUI/GUIObject.lua")
Script.Load("lua/GUI/wrappers/CursorInteractable.lua")

local emoteVectorSize = Vector( 80, 80, 0 )
local emoteGrey = PrecacheAsset("ui/smileyBW.dds")
local emoteGlow = PrecacheAsset("ui/smiley.dds")
local emoteRed = PrecacheAsset("ui/smileyRed.dds")
local emotemenuBG = PrecacheAsset("ui/thunderdome/plaque_rightclickmenu_bg.dds")

local baseClass = GUIObject
baseClass = GetCursorInteractableWrappedClass(baseClass)
class "PlusEmoteButton" (baseClass)


function PlusEmoteButton:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1

    baseClass.Initialize(self, params, errorDepth)

    self:SetSize( emoteVectorSize )

    self.icon = CreateGUIObject( "icon", GUIGraphic, self, nil, errorDepth )
    self.icon:AlignCenter()
    self.icon:SetTexture(emoteGrey)
    self.icon:SetSize( emoteVectorSize )

    self.iconActive = CreateGUIObject( "iconActive", GUIGraphic, self, nil, errorDepth )
    self.iconActive:AlignCenter()
    self.iconActive:SetTexture(emoteGlow)
    self.iconActive:SetSize( emoteVectorSize )
    self.iconActive:SetVisible(false)

    self.iconRed = CreateGUIObject( "iconRed", GUIGraphic, self, nil, errorDepth )
    self.iconRed:AlignCenter()
    self.iconRed:SetTexture(emoteRed)
    self.iconRed:SetSize( emoteVectorSize )
    self.iconRed:SetVisible(false)

    self.icon:SetColor( Color(1,1,1,0.7) )
    self.iconActive:SetColor( Color(1,1,1,0.8) )
    self.iconRed:SetColor( Color(1,1,1,0.8) )


    self.ClickMenu = CreateGUIObject("ClickMenu", GUIGraphic, self, nil, errorDepth)
    self.ClickMenu:SetLayer(99)
    self.ClickMenu:SetVisible(false)
    self.ClickMenu:SetTexture(emotemenuBG)
    self.ClickMenu:SetSizeFromTexture()
    self.ClickMenu:SetSize(306, 366)
    self.ClickMenu:SetColor(1,1,1)
    self.ClickMenu:SetPosition(-250,-330 - 60)



    local positionX = 3
    local positionY = 3
    for i = 2, 31 do

        local emotemenuicon = CreateGUIObject("emoteIcon", GUIButton, self.ClickMenu)

        local emotemenuiconDetails = GetEmoteTextureDetails(i -2 )
        emotemenuicon:SetTexture(emotemenufull)
        emotemenuicon:SetTexturePixelCoordinates(emotemenuiconDetails.texCoords)
        emotemenuicon:SetColor(1,1,1)
        emotemenuicon:SetSize(60, 60)
        emotemenuicon:SetPosition(positionX, positionY)
        emotemenuicon:SetVisible(true)
        emotemenuicon:SetLayer(1000)
        self:HookEvent(emotemenuicon, "OnPressed", function() self:FireEvent(tostring(i)) end)
        self:HookEvent(emotemenuicon, "OnMouseOverChanged", function() PlayMenuSound("ButtonHover") end)

        positionX = (positionX + 60) % 300
        if ( i -1 ) % 5 == 0 then -- -1 because we start at 2 due to the empty emote
          positionY = positionY + 60
        end
    end


    self:HookEvent(self, "OnPressed", self.OnPressed)
    self:HookEvent(self, "OnMouseOverChanged", self.OnHoverChanged)
    self:HookEvent(self, "OnMouseRightClick", self.OnMouseRightClick)

end



function PlusEmoteButton:OnMouseRightClick()
    PlayMenuSound("BeginChoice")
    if self.iconRed:GetVisible() then
      self.iconRed:SetVisible( false )
      self:FireEvent("showEmotes")
    else
      self.iconRed:SetVisible( true )
      self:FireEvent("hideEmotes")
    end
end

--[[
    emote textures are 100x100 or 50x50 even though only 96x96 and 48x48 is used to give room for error for subpixel issues
    emoteId gets the spacecounter of a message (2-31)
]]
function GetEmoteTextureDetails(emoteId)
    local result = {}
    local data = emotemenufull -- contains all emotes, prechached in chatwidget
    if not data then return end
    -- Get zero-based texture coordinates
    local emoteSize = 100
    local nCols = 5
    local x1, y1, x2, y2
    local row = math.floor(emoteId / nCols)
    local col = emoteId % nCols
    x1 = (col * emoteSize)
    y1 = (row * emoteSize)
    x2 = x1 + emoteSize
    y2 = y1 + emoteSize
    result.texCoords = { x1, y1, x2, y2}
    return result
end


function PlusEmoteButton:OnHoverChanged()
    PlayMenuSound("ButtonHover")
    self.iconActive:SetVisible( not self.iconActive:GetVisible() )
    self.icon:SetVisible( not (self.iconActive:GetVisible() or self.iconRed:GetVisible()) )
end

function PlusEmoteButton:OnPressed()
    PlayMenuSound("BeginChoice")
	

    if self.ClickMenu:GetVisible() then
        self.ClickMenu:SetVisible(false)
    else
        self.ClickMenu:SetVisible(true)
    end

    self:FireEvent("setChatFocused")
end