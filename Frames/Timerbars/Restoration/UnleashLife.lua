local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local UnleashLifeBar = SSA.UnleashLifeBar

UnleashLifeBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,1,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

UnleashLifeBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)