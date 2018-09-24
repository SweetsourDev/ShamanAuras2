local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthbindTotemBar = SSA.EarthbindTotemBar

EarthbindTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,2484)) then
		Auras:RunTimerBarCode(self)
	end
end)

--EarthbindTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EarthbindTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)