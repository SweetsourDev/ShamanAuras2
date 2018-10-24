local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local AstralShiftBar = SSA.AstralShiftBar

-- Initialize Data Variables
AstralShiftBar.spellID = 108271
AstralShiftBar.start = 0
AstralShiftBar.duration = 8
AstralShiftBar.condition = function()
	return IsSpellKnown(108271)
end

AstralShiftBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

AstralShiftBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)