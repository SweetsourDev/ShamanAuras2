local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local HeroismBar = SSA.HeroismBar

-- Initialize Data Variables
HeroismBar.spellID = 32182
HeroismBar.start = 0
HeroismBar.duration = 40
HeroismBar.elapsed = 0
HeroismBar.condition = function()
	return true
end

HeroismBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

HeroismBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
	end
end)