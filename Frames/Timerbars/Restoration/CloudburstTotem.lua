local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CloudburstTotemBar = SSA.CloudburstTotemBar

CloudburstTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,6,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

CloudburstTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)