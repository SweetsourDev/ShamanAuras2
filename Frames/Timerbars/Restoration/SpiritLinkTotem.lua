local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SpiritLinkTotemBar = SSA.SpiritLinkTotemBar

-- Initialize Data Variables
SpiritLinkTotemBar.spellID = 98008
SpiritLinkTotemBar.icon = 237586
SpiritLinkTotemBar.start = 0
SpiritLinkTotemBar.duration = 6
SpiritLinkTotemBar.condition = function()
	return IsSpellKnown(98008)
end

SpiritLinkTotemBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

SpiritLinkTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)