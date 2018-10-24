local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local TremorTotemBar = SSA.TremorTotemBar

-- Initialize Data Variables
TremorTotemBar.spellID = 8143
TremorTotemBar.icon = 136108
TremorTotemBar.start = 0
TremorTotemBar.duration = 10
TremorTotemBar.condition = function()
	return IsSpellKnown(8143)
end

TremorTotemBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

TremorTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)