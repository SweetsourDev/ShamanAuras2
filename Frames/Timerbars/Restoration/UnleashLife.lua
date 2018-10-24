local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local UnleashLifeBar = SSA.UnleashLifeBar

-- Initialize Data Variables
UnleashLifeBar.spellID = 73685
UnleashLifeBar.start = 0
UnleashLifeBar.duration = 10
UnleashLifeBar.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)

	return selected
end

UnleashLifeBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

UnleashLifeBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)