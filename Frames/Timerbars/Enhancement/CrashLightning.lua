local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CrashLightningBar = SSA.CrashLightningBar

CrashLightningBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,187874)) then
		Auras:RunTimerBarCode(self)
	end
end)

--CrashLightningBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
CrashLightningBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)