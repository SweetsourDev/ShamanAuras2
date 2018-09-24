local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SkyfuryTotemBar = SSA.SkyfuryTotemBar

SkyfuryTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3488") or Auras:CharacterCheck(self,2,"3487") or Auras:CharacterCheck(self,3,"707")) then
		Auras:RunTimerBarCode(self)
	end
end)

--SkyfuryTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
SkyfuryTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)