local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FeralSpiritBar = SSA.FeralSpiritBar

-- Initialize Data Variables
FeralSpiritBar.spellID = 228562
FeralSpiritBar.icon = 237577
FeralSpiritBar.start = 0
FeralSpiritBar.duration = 15
FeralSpiritBar.lives = 2
FeralSpiritBar.condition = function()
	return IsSpellKnown(51533)
end

FeralSpiritBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

FeralSpiritBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
end)