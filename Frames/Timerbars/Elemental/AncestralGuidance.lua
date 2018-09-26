local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTime = GetTime

-- Cache Global Addon Variables
local AncestralGuidanceBar = SSA.AncestralGuidanceBar

AncestralGuidanceBar.spellID = 108281
AncestralGuidanceBar.start = 0
AncestralGuidanceBar.duration = 10
AncestralGuidanceBar.condition = function() return select(4,GetTalentInfo(5,2,1)) end

AncestralGuidanceBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,5,2)) then
		Auras:RunTimerBarCode(self)
	end
end)

AncestralGuidanceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)