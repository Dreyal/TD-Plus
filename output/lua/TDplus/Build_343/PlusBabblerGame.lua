

Script.Load("lua/GUI/GUIObject.lua")
Script.Load("lua/GUI/wrappers/CursorInteractable.lua")

local targetSize = Vector( 100, 100, 0 )
local targetSizeGlow = Vector( 125, 125, 0 )
local targetPic = PrecacheAsset("ui/TDbabblerSmall.dds")
local targetPicGlow = PrecacheAsset("ui/TDbabblerGlow.dds")

local clickCount = 0
local starttime = 0
local endtime = 0
local highscore = 0

local baseClass = GUIObject
baseClass = GetCursorInteractableWrappedClass(baseClass)
--baseClass = GetTooltipWrappedClass(baseClass)
class "PlusBabblerGame" (baseClass)

function PlusBabblerGame:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1

    baseClass.Initialize(self, params, errorDepth)

    self:SetSize( targetSize )

    self.icon = CreateGUIObject( "icon", GUIGraphic, self, nil, errorDepth )
    self.icon:AlignCenter()
    self.icon:SetTexture(targetPic)
    self.icon:SetSize( targetSize )

    self.iconActive = CreateGUIObject( "iconActive", GetTooltipWrappedClass(GUIGraphic), self, nil, errorDepth )
    self.iconActive:AlignCenter()
    self.iconActive:SetTexture(targetPicGlow)
    self.iconActive:SetSize( targetSizeGlow )
    self.iconActive:SetVisible(false)

    self.icon:SetColor( Color(1,1,1,0.7) )
    self.iconActive:SetColor( Color(1,1,1,0.8) )

    self:HookEvent(self, "OnPressed", self.OnPressed)
    self:HookEvent(self, "SetPassive", self.SetPassive)
    self:HookEvent(self, "OnMouseOverChanged", self.OnHoverChanged)
end

function PlusBabblerGame:SetPassive()
    self.icon:SetColor( Color(1,1,1,0.7) )
    self.iconActive:SetColor( Color(1,1,1,0.8) )
    self:SetPosition(1930, 30 )
    clickCount = 0
    starttime = 0
end

function PlusBabblerGame:OnHoverChanged()
    PlayMenuSound("ButtonHover")
    self.iconActive:SetVisible( not self.iconActive:GetVisible() )
    self.icon:SetVisible( not self.icon:GetVisible() )
end

function PlusBabblerGame:OnPressed()
    PlayMenuSound("BeginChoice")
    local x = math.random(716,2381)
    local y = math.random(152,1230)

    if clickCount == 0 then
      self:Chat("TD Plus", "Shot 10 Babblers!")
      x = 1548
      y = 691
      starttime =  Shared.GetTime()
      self.icon:SetColor( Color(1,1,1,1) )
      self.iconActive:SetColor( Color(1,1,1,1) )

    elseif (clickCount % 10 == 0) then -- nach jeweils 10
        endtime =  Shared.GetTime()
        if highscore == 0 then  -- ende erster Runde
            highscore = endtime-starttime
            self:Chat("TD Plus", "Time: " .. string.sub(tostring(endtime-starttime), 1, 5) )

        elseif endtime-starttime < highscore then -- Highscore
            self:Chat("TD Plus", "Time: " .. string.sub(tostring(endtime-starttime), 1, 5) .. " New Highscore!")
            highscore = endtime-starttime
        else -- kein highscore
            self:Chat("TD Plus", "Time: " .. string.sub(tostring(endtime-starttime), 1, 5))
        end

        if endtime - starttime < 5.5 then
          PlayMenuSound("CustomizeBmacCombatVoice5")
        elseif endtime - starttime < 5.8 then
          PlayMenuSound("CustomizeBmacFriendVoice5")
        elseif endtime - starttime < 6.1 then
          PlayMenuSound("CustomizeFemaleVoice5")
        elseif endtime - starttime < 6.5 then
          PlayMenuSound("CustomizeMaleVoice5")
        end

        starttime = Shared.GetTime()
    end

    self:SetPosition( x, y)

    if clickCount == 50 then
      self.icon:SetColor( Color(1,1,1,0.8) )
      self.iconActive:SetColor( Color(1,1,1,0.9) )
    elseif
      clickCount == 60 then
      self.icon:SetColor( Color(1,1,1,0.6) )
      self.iconActive:SetColor( Color(1,1,1,0.7) )
    elseif
      clickCount == 70 then
      self.icon:SetColor( Color(1,1,1,0.4) )
      self.iconActive:SetColor( Color(1,1,1,0.5) )
    elseif
      clickCount == 80 then
      self.icon:SetColor( Color(1,1,1,0.3) )
      self.iconActive:SetColor( Color(1,1,1,0.4) )
    elseif
      clickCount == 90 then
      self.icon:SetColor( Color(1,1,1,0.2) )
      self.iconActive:SetColor( Color(1,1,1,0.3) )
    elseif
      clickCount == 100 then
      self.icon:SetColor( Color(1,1,1,0.1) )
      self.iconActive:SetColor( Color(1,1,1,0.2) )
    elseif
      clickCount == 110 then
      self.icon:SetColor( Color(1,1,1,0) )
      self.iconActive:SetColor( Color(1,1,1,0.1) )
    end
      clickCount = clickCount + 1
end

-- sender doesnt show up, when the last message was by this command too
function PlusBabblerGame:Chat(sender, chatMessage)
      local td = Thunderdome()
      Thunderdome():TriggerEvent( kThunderdomeEvents.OnGUIChatMessage,td:GetActiveLobbyId(), sender, chatMessage, 0, 13 )
end
