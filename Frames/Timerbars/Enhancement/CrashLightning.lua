local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CrashLightningBar = SSA.CrashLightningBar

-- Initialize Data Variables
CrashLightningBar.spellID = 187878
CrashLightningBar.start = 0
CrashLightningBar.duration = 10
CrashLightningBar.elapsed = 0
CrashLightningBar.condition = function()
	return IsSpellKnown(187874)
end

CrashLightningBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

CrashLightningBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)