

Script.Load("lua/GUI/GUIObject.lua")
Script.Load("lua/menu2/wrappers/Tooltip.lua")
Script.Load("lua/GUI/wrappers/CursorInteractable.lua")


local guideTexture = PrecacheAsset("ui/marineTechPath.dds")
local commbadgeTexture = PrecacheAsset("ui/thunderdome/planning_splash_marines_logo.dds")


local baseClass = GUIObject
baseClass = GetCursorInteractableWrappedClass(baseClass)
baseClass = GetTooltipWrappedClass(baseClass)

class "PlusMarineGuide" (baseClass)

function PlusMarineGuide:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1

    baseClass.Initialize(self, params, errorDepth)

    self:SetSize( 130,130 )

    self.marineguide = CreateGUIObject( "guide", GUIGraphic, self, nil, errorDepth )
    --self.marineguide:AlignCenter()
    self.marineguide:SetPosition(-1700, 0)
    self.marineguide:SetTexture(guideTexture)
    self.marineguide:SetSize( 1871,814 )
    self.marineguide:SetVisible(false)

    self.commbadge = CreateGUIObject( "commbadge", GUIGraphic, self, nil, errorDepth )
    self.commbadge:AlignCenter()
    self.commbadge:SetTexture(commbadgeTexture)
    self.commbadge:SetSize( 250,250)
    self.commbadge:SetVisible(true)
    self:SetTooltip("Show Guide")


    self.marineguide:SetColor( Color(1,1,1,1) )
    self.commbadge:SetColor( Color(1,1,1,0.7) )
    self.isbright = false

    self:HookEvent(self, "OnPressed", self.OnPressed)
    self:HookEvent(self, "OnMouseOverChanged", self.OnHoverChanged)
end


function PlusMarineGuide:OnHoverChanged()
    PlayMenuSound("ButtonHover")

    if self.isbright then 
        self.commbadge:SetColor( Color(1,1,1,0.7) )
        self.isbright = false
    else 
        self.commbadge:SetColor( Color(1,1,1,1) )
        self.isbright = true
    end
end

function PlusMarineGuide:OnPressed()
    PlayMenuSound("BeginChoice")

    if self:GetTooltip() == "Show Guide" then 
        self:SetTooltip("Hide Guide")
    else 
        self:SetTooltip("Show Guide")
    end
    self.marineguide:SetVisible( not self.marineguide:GetVisible() )
    self.commbadge:SetVisible( not self.commbadge:GetVisible() )
   
end

