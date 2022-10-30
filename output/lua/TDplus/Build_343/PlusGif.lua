
Script.Load("lua/GUI/GUIObject.lua")

class "PlusGif" (GUIObject)

PlusGif.kFlipbookShader  = PrecacheAsset("shaders/GUI/menu/flipbook.surface_shader")
PlusGif.kFlipbookTexture_FrameSize = Vector(100, 100, 0)

-- set to 1. All emotes are gifs with only 1 frame
PlusGif.kFramesPerSecond  = 1
PlusGif.kHorizontalFrames = 1
PlusGif.kVerticalFrames   = 1
PlusGif.kTotalFrames      = 1

function PlusGif:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1

    GUIObject.Initialize(self, params, errorDepth)

    self:SetShader(self.kFlipbookShader)
    self:SetFloatParameter("framesPerSecond",  self.kFramesPerSecond )
    self:SetFloatParameter("horizontalFrames", self.kHorizontalFrames)
    self:SetFloatParameter("verticalFrames",   self.kVerticalFrames  )
    self:SetFloatParameter("numFrames",        self.kTotalFrames     )

    self:SetColor(1,1,1)
end
