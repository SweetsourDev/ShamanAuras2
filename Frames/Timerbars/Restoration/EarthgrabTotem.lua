local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthgrabTotemBar = SSA.EarthgrabTotemBar

EarthgrabTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,3,2)) then
		Auras:RunTimerBarCode(self)
	end
end)

EarthgrabTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)