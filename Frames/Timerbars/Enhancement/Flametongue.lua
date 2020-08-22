local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FlametongueBar = SSA.FlametongueBar

-- Initialize Data Variables
FlametongueBar.spellID = 194084
FlametongueBar.start = 0
FlametongueBar.duration = 16
FlametongueBar.elapsed = 0
FlametongueBar.condition = function()
	return IsSpellKnown(193796)
end

FlametongueBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

FlametongueBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end

	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)