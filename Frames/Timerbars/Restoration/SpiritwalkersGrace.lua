local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SpiritwalkersGraceBar = SSA.SpiritwalkersGraceBar

-- Initialize Data Variables
SpiritwalkersGraceBar.spellID = 79206
SpiritwalkersGraceBar.start = 0
SpiritwalkersGraceBar.duration = 15
SpiritwalkersGraceBar.elapsed = 0
SpiritwalkersGraceBar.condition = function()
	return IsSpellKnown(79206)
end

SpiritwalkersGraceBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

SpiritwalkersGraceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)