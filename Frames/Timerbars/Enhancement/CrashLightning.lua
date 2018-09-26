local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CrashLightningBar = SSA.CrashLightningBar

-- Initialize Data Variables
CrashLightningBar.spellID = 187878
CrashLightningBar.start = 0
CrashLightningBar.duration = 10
CrashLightningBar.condition = function() return IsSpellKnown(187874) end

CrashLightningBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,187874)) then
		Auras:RunTimerBarCode(self)
	end
end)

CrashLightningBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)