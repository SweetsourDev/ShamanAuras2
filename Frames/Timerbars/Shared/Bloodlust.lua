local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local BloodlustBar = SSA.BloodlustBar

-- Initialize Data Variables
BloodlustBar.spellID = 2825
BloodlustBar.start = 0
BloodlustBar.duration = 40
BloodlustBar.elapsed = 0
BloodlustBar.condition = function() 
	return true
end

BloodlustBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

BloodlustBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
	end
end)