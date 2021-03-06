local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FlametongueBar = SSA.FlametongueBar

-- Initialize Data Variables
FlametongueBar.spellID = 194084
FlametongueBar.start = 0
FlametongueBar.duration = 16
FlametongueBar.condition = function()
	return IsSpellKnown(193796)
end

FlametongueBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

FlametongueBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end

	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)