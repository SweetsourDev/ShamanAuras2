local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local WindRushTotemBar = SSA.WindRushTotemBar

WindRushTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,5,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

--WindRushTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
WindRushTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)