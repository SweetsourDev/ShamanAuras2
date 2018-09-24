local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTime = GetTime

-- Cache Global Addon Variables
local AncestralGuidanceBar = SSA.AncestralGuidanceBar

AncestralGuidanceBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,5,2)) then
		Auras:RunTimerBarCode(self)
	end
end)

--AncestralGuidanceBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
AncestralGuidanceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)