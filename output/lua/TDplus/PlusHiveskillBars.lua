
Script.Load("lua/GUI/GUIObject.lua")

class "PlusHiveskillBars" (GUIObject)

function PlusHiveskillBars:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1

    GUIObject.Initialize(self, params, errorDepth)

    self.textround1 = CreateGUIObject( "text", GUIText, self, nil, errorDepth )
    self.textround1:SetFontFamily("Microgramma")
    self.textround1:SetFontSize(25)
    self.textround1:AlignTopRight()
    self.textround1:SetText("Round 1")
    self.textround1:SetPosition(Vector(-160, 155, 0))

    self.text1 = CreateGUIObject( "text", GUIText, self, nil, errorDepth )
    self.text1:SetFontFamily("Microgramma")
    self.text1:SetFontSize(20)
    self.text1:AlignTopRight()
    self.text1:SetText("0 avg")
    self.text1:SetPosition(Vector(-350, 200, 0))

    self.text2 = CreateGUIObject( "text", GUIText, self, nil, errorDepth )
    self.text2:SetFontFamily("Microgramma")
    self.text2:SetFontSize(20)
    self.text2:AlignTopRight()
    self.text2:SetText("0 avg")
    self.text2:SetPosition(Vector(-350, 260, 0))

    self.graph = CreateGUIObject( "bar", GUIGraphic, self, nil, errorDepth )
    self.graph:AlignTopRight()
    self.graph:SetLayer(2001)
    self.graph:SetSize(Vector(0, 40, 0))
    self.graph:SetColor(kMarineFontColor)
    self.graph:SetPosition(Vector(-330, 200, 0))

    self.graph2 = CreateGUIObject( "bar", GUIGraphic, self, nil, errorDepth )
    self.graph2:AlignTopRight()
    self.graph2:SetLayer(2001)
    self.graph2:SetSize(Vector(0, 40, 0))
    self.graph2:SetColor(kAlienFontColor)
    self.graph2:SetPosition(Vector(-330, 260, 0))

    self.textround2 = CreateGUIObject( "text", GUIText, self, nil, errorDepth )
    self.textround2:SetFontFamily("Microgramma")
    self.textround2:SetFontSize(25)
    self.textround2:AlignTopRight()
    self.textround2:SetText("Round 2")
    self.textround2:SetPosition(Vector(-160, 305, 0))

    self.text3 = CreateGUIObject( "text", GUIText, self, nil, errorDepth )
    self.text3:SetFontFamily("Microgramma")
    self.text3:SetFontSize(20)
    self.text3:AlignTopRight()
    self.text3:SetText("0 avg")
    self.text3:SetPosition(Vector(-350, 350, 0))

    self.text4 = CreateGUIObject( "text", GUIText, self, nil, errorDepth )
    self.text4:SetFontFamily("Microgramma")
    self.text4:SetFontSize(20)
    self.text4:AlignTopRight()
    self.text4:SetText("0 avg")
    self.text4:SetPosition(Vector(-350, 410, 0))

    self.graph3 = CreateGUIObject( "bar", GUIGraphic, self, nil, errorDepth )
    self.graph3:AlignTopRight()
    self.graph3:SetLayer(2001)
    self.graph3:SetSize(Vector(0, 40, 0))
    self.graph3:SetColor(kMarineFontColor)
    self.graph3:SetPosition(Vector(-330, 350, 0))

    self.graph4 = CreateGUIObject( "bar", GUIGraphic, self, nil, errorDepth )
    self.graph4:AlignTopRight()
    self.graph4:SetLayer(2001)
    self.graph4:SetSize(Vector(0, 40, 0))
    self.graph4:SetColor(kAlienFontColor)
    self.graph4:SetPosition(Vector(-330, 410, 0))
  end


function PlusHiveskillBars:calcTeamskillgraph(debug)
    local memberModel = Thunderdome():GetMemberListLocalData(Thunderdome():GetActiveLobbyId())
    if not memberModel then return end

    local totalskillteam1 = 0
    local totalskillteam2 = 0
    local totalskillteam3 = 0
    local totalskillteam4 = 0

    local team1count = 0
    local team2count = 0
    local team3count = 0
    local team4count = 0

    for i = 1, #memberModel do
        local team = memberModel[i].team
        local marineskill = memberModel[i].marine_skill
        local alienskill = memberModel[i].alien_skill

        if team == 1 then
            totalskillteam1 = marineskill + totalskillteam1
            team1count = team1count + 1
            totalskillteam4 = alienskill + totalskillteam4
            team4count = team4count + 1

        elseif team == 2 then
            totalskillteam2 = alienskill + totalskillteam2
            team2count = team2count + 1
            totalskillteam3 = marineskill + totalskillteam3
            team3count = team3count + 1
        end
    end

    if team1count + team2count ~= 12 or team3count + team4count ~= 12 then

        self:SetVisible(false)

        for j = 1, #memberModel do
            local name = memberModel[j].name
            Log("player #%d %s", j, name)
        end

        
        if debug == true then 
            self:SetVisible(true)
        end

        Shared.Message("Missing data for 1+ player at hiveskillbars")
        return
    end

    local avgteam1 = math.floor(totalskillteam1 / team1count )
    local avgteam2 = math.floor(totalskillteam2 / team2count )

    local avgteam3 = math.floor(totalskillteam3 / team3count )
    local avgteam4 = math.floor(totalskillteam4 / team4count )
    self.text1:SetText(tostring(avgteam1) .. " avg")
    self.text2:SetText(tostring(avgteam2) .. " avg")
    self.text3:SetText(tostring(avgteam3) .. " avg")
    self.text4:SetText(tostring(avgteam4) .. " avg")
    self.graph:SetSize(Vector((-avgteam1 ) / 10, 40, 0))
    self.graph2:SetSize(Vector((-avgteam2 ) / 10, 40, 0))
    self.graph3:SetSize(Vector((-avgteam3) / 10, 40, 0))
    self.graph4:SetSize(Vector((-avgteam4) / 10, 40, 0))

    Shared.Message(string.format("Round 1: Marines %s - Aliens %s, Round 2: Marines %s - Aliens %s", tostring(avgteam1), tostring(avgteam2), tostring(avgteam3), tostring(avgteam4) ))
    self:SetVisible(true)
end
