local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local HealingTideTotemBar = SSA.HealingTideTotemBar

-- Initialize Data Variables
HealingTideTotemBar.spellID = 108280
HealingTideTotemBar.icon = 538569
HealingTideTotemBar.start = 0
HealingTideTotemBar.duration = 10
HealingTideTotemBar.condition = function()
	return IsSpellKnown(108280)
end

HealingTideTotemBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

HealingTideTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)