local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FrostbrandBar = SSA.FrostbrandBar

-- Initialize Data Variables
FrostbrandBar.spellID = 196834
FrostbrandBar.start = 0
FrostbrandBar.duration = 16
FrostbrandBar.elapsed = 0
FrostbrandBar.condition = function()
	return IsSpellKnown(196834)
end

FrostbrandBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

FrostbrandBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)