local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local MountainDrumsBar = SSA.MountainDrumsBar

-- Initialize Data Variables
MountainDrumsBar.spellID = 230935
MountainDrumsBar.start = 0
MountainDrumsBar.duration = 40
MountainDrumsBar.elapsed = 0
MountainDrumsBar.condition = function() 
	return true
end

MountainDrumsBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

MountainDrumsBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
	end
end)