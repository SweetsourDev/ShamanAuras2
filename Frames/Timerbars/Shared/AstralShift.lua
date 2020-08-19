local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local AstralShiftBar = SSA.AstralShiftBar

-- Initialize Data Variables
AstralShiftBar.spellID = 108271
AstralShiftBar.start = 0
AstralShiftBar.duration = 8
AstralShiftBar.elapsed = 0
AstralShiftBar.condition = function()
	return IsSpellKnown(108271)
end

AstralShiftBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

AstralShiftBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)