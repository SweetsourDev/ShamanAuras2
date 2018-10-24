local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SpiritwalkersGraceBar = SSA.SpiritwalkersGraceBar

-- Initialize Data Variables
SpiritwalkersGraceBar.spellID = 79206
SpiritwalkersGraceBar.start = 0
SpiritwalkersGraceBar.duration = 15
SpiritwalkersGraceBar.condition = function()
	return IsSpellKnown(79206)
end

SpiritwalkersGraceBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

SpiritwalkersGraceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)