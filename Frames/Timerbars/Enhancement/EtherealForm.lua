local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EtherealFormBar = SSA.EtherealFormBar

EtherealFormBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,"1944")) then
		Auras:RunTimerBarCode(self)
	end
end)

EtherealFormBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)