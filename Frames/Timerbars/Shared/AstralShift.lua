local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local AstralShiftBar = SSA.AstralShiftBar

AstralShiftBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,108271)) then
		Auras:RunTimerBarCode(self)
	end
end)

--AstralShiftBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
AstralShiftBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)