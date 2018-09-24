local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTime = GetTime

-- Cache Global Addon Variables
local ElementalBlastBarCrit = SSA.ElementalBlastBarCrit
local ElementalBlastBarHaste = SSA.ElementalBlastBarHaste
local ElementalBlastBarMastery = SSA.ElementalBlastBarMastery

--ElementalBlastBarCrit:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ElementalBlastBarCrit:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,1,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

ElementalBlastBarCrit:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)

--ElementalBlastBarHaste:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ElementalBlastBarHaste:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,1,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

ElementalBlastBarHaste:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)

--ElementalBlastBarMastery:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ElementalBlastBarMastery:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,1,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

ElementalBlastBarMastery:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)


