local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local AscendanceBar = SSA.AscendanceBar

AscendanceBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,7,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

--AscendanceBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
AscendanceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)