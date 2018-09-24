local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local HealingTideTotemBar = SSA.HealingTideTotemBar

HealingTideTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,108280)) then
		Auras:RunTimerBarCode(self)
	end
end)

HealingTideTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)